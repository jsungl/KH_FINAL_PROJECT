package com.kh.nana.mypage.controller;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.nana.board.model.vo.Board;
import com.kh.nana.board.model.vo.BoardComment;
import com.kh.nana.common.util.HelloSpringUtils;
import com.kh.nana.member.mail.MailInit;
import com.kh.nana.member.model.service.MemberService;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.mypage.model.service.CourseService;
import com.kh.nana.mypage.model.vo.Course;
import com.kh.nana.mypage.model.vo.CourseExt;
import com.kh.nana.mypage.model.vo.CourseNo;
import com.kh.nana.mypage.model.vo.CourseNoList;
import com.kh.nana.mypage.model.vo.CoursePhoto;
import com.kh.nana.mypage.model.vo.MyBoardLike;
import com.kh.nana.mypage.model.vo.MyPlaceLike;

import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Controller
@RequestMapping("/mypage")
@Slf4j
public class MypageController {
	@Autowired
	private ServletContext application;

	@Autowired
	private ResourceLoader resourceLoader;

	@Autowired
	private CourseService courseService;

	@Autowired
	private MemberService memberService;

	//메일전송(인증코드생성)
	private MailInit mailInit;
	@Autowired
	private void setMailInit(MailInit mailInit) {
		this.mailInit = mailInit;
	}

	@Autowired
	private JavaMailSenderImpl mailSender;

	ClassPathResource resource = new ClassPathResource("apikeys.properties");
	Properties prop = new Properties();

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}

	@GetMapping("/mypage")
	public void MyPage(Authentication authentication, Model model) {
		log.debug("authentication = {}", authentication);
		Member principal = (Member)authentication.getPrincipal();

		model.addAttribute("principal", principal);
	}

	@GetMapping("/memberDelete")
	public String MemberDelete(Authentication authentication,
			RedirectAttributes redirectAttr, Model model) {
		log.debug("authentication = {}", authentication);
		Member principal = (Member)authentication.getPrincipal();
		
		int result = memberService.deleteMember(principal.getId());

		if(result>0) {
			redirectAttr.addFlashAttribute("msg", "떠나신다니 아쉽습니다.");
			SecurityContextHolder.clearContext();
		}
		else {
			redirectAttr.addFlashAttribute("msg", "회원정보삭제에 실패했습니다.");
		}
		
		return "redirect:/";
	}

	@GetMapping("/memberUpdateForm")
	public void MemberUpdateForm(Authentication authentication, Model model) {
		log.debug("authentication = {}", authentication);
		Member principal = (Member)authentication.getPrincipal();

		model.addAttribute("principal", principal);
	}

	@GetMapping("/emailPop")
	public void EmailPop(Authentication authentication, Model model) {
		log.debug("authentication = {}", authentication);
		Member principal = (Member)authentication.getPrincipal();

		model.addAttribute("principal", principal);
	}

	@GetMapping("/phonePop")
	public void PhonePop(Authentication authentication, Model model) {
		log.debug("authentication = {}", authentication);
		Member principal = (Member)authentication.getPrincipal();

		model.addAttribute("principal", principal);
	}

	@PostMapping("/memberUpdate.do")
	public String memberUpdate(@ModelAttribute Member member,
			RedirectAttributes redirectAttr) {
		
		log.debug("member = {}", member);

		if(member.getPassword() != null) {
			String rawPassword = member.getPassword();
			String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
			member.setPassword(encodedPassword);
			log.info("member(암호화처리이후) = {}",member);
		}
		
		int result = courseService.memberUpdate(member);

		if(result > 0) {
			redirectAttr.addFlashAttribute("msg", "회원정보 수정 완료");
		} else {
			redirectAttr.addFlashAttribute("msg", "회원정보 수정에 실패했습니다.");
		}

		return "/mypage/mypage";
		
	}

	@GetMapping("/mypageActive")
	public String MypageActive(
			@RequestParam(name="myBoard" ,required = true, defaultValue = "posting") String myBoard,
			@RequestParam(required = true, defaultValue = "1") int cpage,
			Authentication authentication,
			HttpServletRequest request,
			Model model) {
		
		try {
			Member principal = (Member)authentication.getPrincipal();
			
			log.debug("myBoard = {}", myBoard);
			log.debug("cpage = {}", cpage);
			final int limit = 3;
			final int offset = (cpage - 1) * limit;
			Map<String, Object> param = new HashMap<>();
			param.put("limit", limit);
			param.put("offset", offset);
			
			List<Board> boardList = new ArrayList<>();
			List<BoardComment> boardCommentList = new ArrayList<>();
			int totalContents = 0;
			String url = request.getRequestURI();
			String pageBar = "";
			
			// 1.업무로직 : content영역 - Rowbounds
			if(myBoard.equals("posting")) {
				
				List<Board> getBoardList = courseService.selectBoardIdList(principal.getId(), param);
				log.debug("getBoardList = {}", getBoardList);
				totalContents = courseService.selectBoardTotalContents(principal.getId());
				log.debug("totalContents = {}", totalContents);

				pageBar = HelloSpringUtils.getPageBarMypage(totalContents, cpage, limit, url, principal.getId());
				
				for(Board b : getBoardList) {
					b.setContent(HelloSpringUtils.removeTag(b.getContent()));
					boardList.add(b);
				}
				
				log.debug("boardList = {}", boardList);
				
				model.addAttribute("boardList", boardList);
			} else if(myBoard.equals("comment")) {
				
				boardCommentList = courseService.selectBoardCommentIdList(principal.getId(), param);
				log.debug("boardCommentList = {}", boardCommentList);
				totalContents = courseService.selectBoardCommentTotalContents(principal.getId());
				log.debug("totalContents = {}", totalContents);

				pageBar = HelloSpringUtils.getPageBarMypage(totalContents, cpage, limit, url, principal.getId());

				model.addAttribute("boardCommentList", boardCommentList);
			}

			log.debug("totalContents = {}, url = {}", totalContents, url);

			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			model.addAttribute("principal", principal);
			model.addAttribute("pageBar", pageBar);
			
		} catch (Exception e) {
			log.error("게시글 조회 오류!", e);
			throw e;
		}
		return "mypage/mypageActive";
	}

	@GetMapping("/mypageTravel")
	public String MypageTravel(
			@RequestParam(required = true, defaultValue = "1") int cpage,
			Authentication authentication,
			HttpServletRequest request,
			Model model) {
		
		try {
			Member principal = (Member)authentication.getPrincipal();
			
			log.debug("cpage = {}", cpage);
			final int limit = 3;
			final int offset = (cpage - 1) * limit;
			Map<String, Object> param = new HashMap<>();
			param.put("limit", limit);
			param.put("offset", offset);
			
			// 1.업무로직 : content영역 - Rowbounds
			List<CourseNoList> courseNoList = courseService.selectCourseHeadTitleList(principal.getId(), param);
			log.debug("courseNoList = {}", courseNoList);
			int totalContents = courseService.selectCourseTotalContents(principal.getId());
			log.debug("totalContents = {}", totalContents);
			List<Course> course = courseService.selectCourseIdList(principal.getId());
			log.debug("course = {}", course);


			String url = request.getRequestURI();
			log.debug("totalContents = {}, url = {}", totalContents, url);
			String pageBar = HelloSpringUtils.getPageBarMypage(totalContents, cpage, limit, url, principal.getId());

			if (courseNoList.size() > 0) {
				for (CourseNoList cList : courseNoList) {
					List<Course> cAttach = new ArrayList<>();
					for (Course c : course) {
						if (cList.getTitle().equals(c.getTitle()) || cList.getTitle() == c.getTitle()) {
							cAttach.add(c);
						}
					}
					cList.setCourse(cAttach);
				}
			}

			log.debug("courseNoList = {}", courseNoList);

			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			model.addAttribute("principal", principal);
			model.addAttribute("courseNoList", courseNoList);
			model.addAttribute("pageBar", pageBar);
			
		} catch (Exception e) {
			log.error("게시글 조회 오류!", e);
			throw e;
		}
		return "mypage/mypageTravel";
	}

	@GetMapping("/mypageLike")
	public String MypageLike(
			@RequestParam(name="myBoard" ,required = true, defaultValue = "likeBoard") String myBoard,
			@RequestParam(required = true, defaultValue = "1") int cpage,
			Authentication authentication,
			HttpServletRequest request,
			Model model) {
		
		try {
			Member principal = (Member)authentication.getPrincipal();
			
			log.debug("myBoard = {}", myBoard);
			log.debug("cpage = {}", cpage);
			final int limit = 3;
			final int offset = (cpage - 1) * limit;
			Map<String, Object> param = new HashMap<>();
			param.put("limit", limit);
			param.put("offset", offset);
			
			List<MyBoardLike> boardLikeList = new ArrayList<>();
			List<MyPlaceLike> placeLikeList = new ArrayList<>();
			int totalContents = 0;
			String url = request.getRequestURI();
			String pageBar = "";
			
			// 1.업무로직 : content영역 - Rowbounds
			if(myBoard.equals("likeBoard")) {
				
				List<MyBoardLike> getBoardLikeList = courseService.selectBoardLikeList(principal.getId(), param);
				log.debug("getBoardLikeList = {}", getBoardLikeList);
				totalContents = courseService.selectboardLikeContents(principal.getId());
				log.debug("totalContents = {}", totalContents);

				pageBar = HelloSpringUtils.getPageBarMypage(totalContents, cpage, limit, url, principal.getId());

				for(MyBoardLike b : getBoardLikeList) {
					b.setContent(HelloSpringUtils.removeTag(b.getContent()));
					boardLikeList.add(b);
				}

				log.debug("boardLikeList = {}", boardLikeList);
				
				model.addAttribute("boardLikeList", boardLikeList);
			} else if(myBoard.equals("likePlace")) {
				
				placeLikeList = courseService.selectPlaceLikeList(principal.getId(), param);
				log.debug("placeLikeList = {}", placeLikeList);
				totalContents = courseService.selectPlaceLikeTotalContents(principal.getId());
				log.debug("totalContents = {}", totalContents);

				pageBar = HelloSpringUtils.getPageBarMypage(totalContents, cpage, limit, url, principal.getId());

				model.addAttribute("placeLikeList", placeLikeList);
			}

			log.debug("totalContents = {}, url = {}", totalContents, url);

			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			model.addAttribute("principal", principal);
			model.addAttribute("pageBar", pageBar);
			
		} catch (Exception e) {
			log.error("게시글 조회 오류!", e);
			throw e;
		}
		return "mypage/mypageLike";
	}

	@ResponseBody
	@RequestMapping(value = "/titleCheck")
	public int ajaxTitleCheck(@RequestParam("title") String title) {
		return courseService.selectCourseNoList(title);
	}

	@GetMapping("/courseForm")
	public void CousrseForm(Authentication authentication, Model model) {
		Member principal = (Member)authentication.getPrincipal();
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
		
		model.addAttribute("principal", principal);
		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
	}

	@PostMapping("/courseEnroll")
	public String CourseEnroll(
			@ModelAttribute CourseExt course, 
			@RequestParam(name = "photo", required = false) MultipartFile photo,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {

		try {
			log.debug("course = {}", course);
			String saveDirectory = application.getRealPath("/resources/upload/course");
			log.debug("saveDirectory = {}", saveDirectory);
			
			if (photo == null  || photo.isEmpty()) {
				
			} else {
				CoursePhoto cPhoto = new CoursePhoto();
				String renamedFilename = HelloSpringUtils.getRenamedFilename(photo.getOriginalFilename());

				File dest = new File(saveDirectory, renamedFilename);
				photo.transferTo(dest);

				cPhoto.setOriginalFilename(photo.getOriginalFilename());
				cPhoto.setRenamedFilename(renamedFilename);
				
				log.debug("coursePhoto = {}", cPhoto);
				course.setCoursePhoto(cPhoto);
			}
			
			int result = courseService.insertCourse(course);
			
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			
		} catch (Exception e) {
			log.error("여행코스 등록 실패", e);
			throw e;
		}
		String cTitle = URLEncoder.encode(course.getTitle(), "utf-8");
		return "redirect:/mypage/courseFormEnter?title="+cTitle;
	}

	@GetMapping("/courseFormEnter")
	public void CourseFormEnter(@RequestParam("title") String title,
			Authentication authentication, Model model) {

		Member principal = (Member)authentication.getPrincipal();

		List<CourseExt> courseList = courseService.selectCourseOneList(title);
		log.debug("courseList = {}", courseList);
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
		model.addAttribute("principal", principal);
		model.addAttribute("courseTitle", title);
		model.addAttribute("courseList", courseList);

	}

	@PostMapping("/courseDelete")
	public String CourseDelete(
			@RequestParam(name = "no") int no,
			@RequestParam(name = "title") String title,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {

		try {
			log.debug("no = {}", no);
			log.debug("title = {}", title);
			
			int result = courseService.deleteCourse(no);
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			redirectAttr.addFlashAttribute("msg", "성공적으로 여행코스를 삭제했습니다.");
			
		} catch (Exception e) {
			log.error("여행코스 삭제 실패", e);
			throw e;
		}
		String cTitle = URLEncoder.encode(title, "utf-8");
		return "redirect:/mypage/courseFormEnter?title="+cTitle;
	}

	@PostMapping("/courseUpdateDelete")
	public String CourseUpdateDelete(
			@RequestParam(name = "no") int no,
			@RequestParam(name = "title") String title,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {

		try {
			log.debug("no = {}", no);
			log.debug("title = {}", title);
			
			int result = courseService.deleteCourse(no);
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			redirectAttr.addFlashAttribute("msg", "성공적으로 여행코스를 삭제했습니다.");
			
		} catch (Exception e) {
			log.error("여행코스 삭제 실패", e);
			throw e;
		}
		String cTitle = URLEncoder.encode(title, "utf-8");
		return "redirect:/mypage/courseUpdate?title="+cTitle;
	}
	
	@PostMapping("/courseListEnroll")
	public String CourseListEnroll(
			@ModelAttribute CourseNo courseNo,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {
		
		try {
			log.debug("course = {}", courseNo);
			
			int result = courseService.enrollListCourse(courseNo);
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			redirectAttr.addFlashAttribute("msg", "성공적으로 여행코스를 등록했습니다.");
		} catch (Exception e) {
			log.error("여행코스 등록 실패", e);
			throw e;
		}
		return "redirect:/mypage/courseView?no="+courseNo.getCourseNo();
	}

	@GetMapping("/courseView")
	public void CourseView(@RequestParam("no") int no,
			Authentication authentication, Model model) {
		
		log.debug("no = {}", no);
		CourseNo courseNo = courseService.selectCourseNo(no);
		log.debug("courseNo = {}", courseNo);
		List<CourseExt> courseList = courseService.selectCourseOneList(courseNo.getTitle());
		log.debug("courseList = {}", courseList);
		
		CourseExt firstCourse = courseList.get(0);
		log.debug("firstCourse = {}", firstCourse);
		
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
		model.addAttribute("courseNo", courseNo);
		model.addAttribute("firstCourse", firstCourse);
		model.addAttribute("courseList", courseList);

	}

	@GetMapping("/courseUpdate")
	public void CousrseUpdate(@RequestParam("title") String title, 
			Authentication authentication, Model model) {
		
		Member principal = (Member)authentication.getPrincipal();

		List<CourseExt> courseList = courseService.selectCourseOneList(title);
		log.debug("courseList = {}", courseList);
		int travelNo = courseService.findCourseNo(title);
		log.debug("travelNo = {}", travelNo);
		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

		model.addAttribute("kakaoServiceKey", kakaoServiceKey);
		model.addAttribute("principal", principal);
		model.addAttribute("travelNo", travelNo);
		model.addAttribute("courseTitle", title);
		model.addAttribute("courseList", courseList);
		
	}

	@PostMapping("/courseUpdateEnroll")
	public String CourseUpdateEnroll(
			@ModelAttribute CourseExt course, 
			@RequestParam(name = "photo", required = false) MultipartFile photo,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {

		try {
			log.debug("course = {}", course);
			String saveDirectory = application.getRealPath("/resources/upload/course");
			log.debug("saveDirectory = {}", saveDirectory);
			
			if (photo == null  || photo.isEmpty()) {
				
			} else {
				CoursePhoto cPhoto = new CoursePhoto();
				String renamedFilename = HelloSpringUtils.getRenamedFilename(photo.getOriginalFilename());

				File dest = new File(saveDirectory, renamedFilename);
				photo.transferTo(dest);

				cPhoto.setOriginalFilename(photo.getOriginalFilename());
				cPhoto.setRenamedFilename(renamedFilename);
				
				log.debug("coursePhoto = {}", cPhoto);
				course.setCoursePhoto(cPhoto);
			}
			
			int result = courseService.insertCourse(course);
			
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");
			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			
		} catch (Exception e) {
			log.error("여행코스 등록 실패", e);
			throw e;
		}
		String cTitle = URLEncoder.encode(course.getTitle(), "utf-8");
		return "redirect:/mypage/courseUpdate?title="+cTitle;
	}

	@GetMapping("/courseUpdateEnter")
	public String CousrseUpdateEnter(@RequestParam("no") int no, Model model) {
		log.debug("no = {}", no);

		String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

		model.addAttribute("kakaoServiceKey", kakaoServiceKey);

		return "redirect:/mypage/courseView?no="+no;
	}

	@GetMapping("/courseDeleteList")
	public String CourseDeleteList(
			@RequestParam(name = "title") String title,
			Model model,
			RedirectAttributes redirectAttr
			) throws Exception {

		try {
			log.debug("title = {}", title);
			
			int resultNo = courseService.deleteCourseNo(title);
			int resultAll = courseService.deleteCourseAll(title);
			
			String kakaoServiceKey = HelloSpringUtils.getApiKey("apikeys.properties", "kakaoServiceKey");

			model.addAttribute("kakaoServiceKey", kakaoServiceKey);
			redirectAttr.addFlashAttribute("msg", "성공적으로 여행코스를 게시물을 삭제했습니다.");
			
		} catch (Exception e) {
			log.error("여행코스 삭제 실패", e);
			throw e;
		}
		return "redirect:/mypage/mypage";
	}
	

	/**
	 * 회원가입 이메일 인증
	 * @param email
	 * @return
	 * @throws Exception
	 */
	@GetMapping("/sendEmail.do")
	@ResponseBody
	public Map<String,Object> sendMail(@RequestParam String email) throws Exception {
		String mailCode = mailInit.createCode();
		log.debug("mailCode = {}", mailCode);
		
		String subject = "[나홀로 나들이] 인증 이메일입니다.";
        String content = "인증코드 [" + mailCode + "] 입니다.";
        String from = "baguson@gmail.com";
        String to = email;
		log.debug("toEmail = {}", email);
		
		Map<String,Object> param = new HashMap<>();
		boolean result = false;
		try {
            MimeMessage mail = mailSender.createMimeMessage();
            MimeMessageHelper mailHelper = new MimeMessageHelper(mail,true,"UTF-8");
            // true는 멀티파트 메세지를 사용하겠다는 의미
            
            /*
             * 단순한 텍스트 메세지만 사용시엔 아래의 코드도 사용 가능 
             * MimeMessageHelper mailHelper = new MimeMessageHelper(mail,"UTF-8");
             */
            
            mailHelper.setFrom(from);
            // 빈에 아이디 설정한 것은 단순히 smtp 인증을 받기 위해 사용 따라서 보내는이(setFrom())반드시 필요
            // 보내는이와 메일주소를 수신하는이가 볼때 모두 표기 되게 원하신다면 아래의 코드를 사용하시면 됩니다.
            //mailHelper.setFrom("보내는이 이름 <보내는이 아이디@도메인주소>");
            mailHelper.setTo(to);
            mailHelper.setSubject(subject);
            mailHelper.setText(content);
            // true는 html을 사용하겠다는 의미입니다.
            
            /*
             * 단순한 텍스트만 사용하신다면 다음의 코드를 사용하셔도 됩니다. mailHelper.setText(content);
             */
            
            mailSender.send(mail);
            
            result = true;
            param.put("result", result);
            param.put("mailCode", mailCode);
            
        } catch(Exception e) {
        	log.error("메일전송 오류(회원가입시 메일인증)!",e);
			throw e;
        }
		
        return param;
	}

	/**
	 * 이메일 중복검사
	 */
	@GetMapping("/checkEmailDuplicate2.do")
	@ResponseBody
	public Map<String,Object> checkEmailDuplicate2(@RequestParam String email) {
		Map<String,Object> map = new HashMap<>();
		try {
			Member member = memberService.selectOneMemberByEmail(email);
			boolean available = member == null;
			map.put("available", available);
			map.put("email", email);
		} catch(Exception e) {
			log.error("회원이메일 중복검사 오류!",e);
			throw e;
		}
		return map;
	}

	/**
	 * 회원가입 핸드폰번호 인증
	 * @param to
	 * @param code
	 * @return
	 * @throws CoolsmsException
	 */
	@GetMapping("/sendSms.do")
	@ResponseBody
	public Map<String,Object> sendSms(@RequestParam String to, @RequestParam String code) throws CoolsmsException {
		
		 String api_key = "";
	     String api_secret = "";

	     try{
				prop.load(new FileReader(resource.getFile()));
				api_key = prop.getProperty("send_key");
				api_secret = prop.getProperty("send_secret");
				log.debug("api_key = {}",api_key);
				log.debug("api_secret = {}", api_secret);
		 }catch(IOException e){
			e.printStackTrace();
		 }
	     
	     
	     //Coolsms coolsms = new Coolsms(api_key, api_secret);
	     Message coolsms = new Message(api_key, api_secret);

	     HashMap<String, String> set = new HashMap<String, String>();
         set.put("to", to); // 수신번호
         set.put("from", "01050048995"); // 발신번호, jsp에서 전송한 발신번호를 받아 map에 저장한다.
         set.put("text", "나홀로나들이 입니다. 인증번호는 [" + code + "] 입니다."); // 문자내용, jsp에서 전송한 문자내용을 받아 map에 저장한다.
         set.put("type", "sms"); // 문자 타입

         log.debug("set = {}",set);

         JSONObject result = coolsms.send(set); // 보내기&전송결과받기
         log.debug("result = {}", result);
         Map<String,Object> map = new HashMap<>();
         int success_count = Integer.parseInt(String.valueOf(result.get("success_count")));
         log.debug("success_count = {}", success_count);
         
         int error_count = Integer.parseInt(String.valueOf(result.get("error_count")));
         log.debug("error_count = {}", error_count);
         
         if (success_count == 1) {
        	 log.info("문자전송 성공");
        	 map.put("result", true);
         } 
         else if(error_count == 1) {

           // 메시지 보내기 실패
           System.out.println("실패");
           log.info("문자전송 실패");
           log.debug("code = {}", result.get("code"));
           log.debug("message = {}", result.get("message"));
           map.put("result", false);
         }

         return map;	
	}

	
}
