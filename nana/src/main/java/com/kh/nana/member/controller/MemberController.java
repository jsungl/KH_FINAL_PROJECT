package com.kh.nana.member.controller;

import java.beans.PropertyEditor;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.connect.Connection;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.util.UrlPathHelper;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.kh.nana.member.googlelogin.model.GoogleOAuthRequest;
import com.kh.nana.member.googlelogin.model.GoogleOAuthResponse;
import com.kh.nana.member.kakaologin.controller.KakaoController;
import com.kh.nana.member.mail.MailInit;
import com.kh.nana.member.model.service.MemberService;
import com.kh.nana.member.model.vo.Member;
import com.kh.nana.member.naverlogin.oauth.bo.NaverLoginBO;
import com.kh.nana.member.naverlogin.oauth.model.NaverLoginApi;
import com.kh.nana.security.model.service.SecurityService;

import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.Coolsms;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Controller
@RequestMapping("/member")
@Slf4j
public class MemberController {

	@Autowired
	private MemberService memberService;
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	@Autowired
	private JavaMailSenderImpl mailSender;
	
	
	ClassPathResource resource = new ClassPathResource("apikeys.properties");
	Properties prop = new Properties();
	
	//네이버 로그인
	private NaverLoginBO naverLoginBO;
	@Autowired
	private void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}
	
	//구글로그인
//	@Autowired
//	private GoogleConnectionFactory googleConnectionFactory;
//	@Autowired
//	private OAuth2Parameters googleOAuth2Parameters;


	//카카오로그인
	//private KakaoController kakaoController;
	
	private String naverAuthUrl;
	
	//메일전송(인증코드생성)
	private MailInit mailInit;
	@Autowired
	private void setMailInit(MailInit mailInit) {
		this.mailInit = mailInit;
	}
	
	@GetMapping("/memberLogin.do")
	public void memberLogin(Model model, HttpSession session, HttpServletRequest request) {
		
		/* 네이버 로그인 */
		/* 네아로 인증 URL을 생성하기 위하여 getAuthorizationUrl을 호출 */
        naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		//log.debug("로그인 페이지 접속 : naverAuthUrl = {}", naverAuthUrl);
		//네아로 인증 url을 view로 전달
		model.addAttribute("naver_url", naverAuthUrl);

		/* 카카오 로그인*/
		String kakaoUrl = KakaoController.getAuthorizationUrl(session);
		//log.debug("kakao_url = {}",kakaoUrl);
		model.addAttribute("kakao_url", kakaoUrl);
		
		String referer = request.getHeader("Referer");
		//log.debug("referer = {}", referer);
		if(referer == null || !referer.contains("/memberLogin.do")) {
			request.getSession().setAttribute("prevPage",request.getHeader("Referer"));
		}
		
	}
	
	@PostMapping("/memberLogout.do")
	public void memberLogout() {}
		
	
	@GetMapping("/memberEnroll.do")
	public void memberEnroll() {
		
	}
	
	@GetMapping("/memberSearch.do")
	public void memberSearch() {
		
	}
	
	/**
	 * 회원가입
	 * @param member
	 * @param redirectAttr
	 * @return
	 */
	@PostMapping("/memberEnroll.do")
	public String memberEnroll(Member member, RedirectAttributes redirectAttr) {
		log.info("member = {}",member);
		try {
			//0. 비밀번호 암호화처리
			String rawPassword = member.getPassword();
			String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
			member.setPassword(encodedPassword);
			//log.info("member(암호화처리이후) = {}",member);
			
			//1. 업무로직
			int result = memberService.insertMember(member);
		
			//2. 사용자피드백
			redirectAttr.addFlashAttribute("msg", "회원가입성공");
		
		} catch(Exception e) {
			log.error("회원가입 오류!",e);
			throw e;
		}
		
		return "redirect:/";
		
	}
	
	@GetMapping("/moreInfo.do")
	public void memberAddEnroll() {
		log.info("moreInfo.do getMapping호출");
	}
	
	/**
	 * 회원정보 추가입력
	 * @param member
	 * @param redirectAttr
	 * @return
	 */
	@PostMapping("/moreInfo.do")
	public String memberAddEnroll(Member member, RedirectAttributes redirectAttr) {
		//log.info("member = {}",member);
		try {
			//0. 비밀번호 암호화처리
			String rawPassword = member.getPassword();
			String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
			member.setPassword(encodedPassword);
			
			int result = memberService.insertMember(member);
			redirectAttr.addFlashAttribute("msg", "회원정보 추가입력 성공");
			
			member = memberService.loadUserByUserEmail(member.getEmail());
			setAuthentication(member);
			
		} catch(Exception e) {
			log.error("회원정보 추가입력 오류!",e);
			throw e;
		}
		
		return "redirect:/";
	}
	
	/**
	 * Authentication설정
	 * @param member
	 */
	public void setAuthentication(Member member) {
//		List<SimpleGrantedAuthority> roles = new ArrayList<>();
//		roles.add(new SimpleGrantedAuthority("ROLE_USER"));
//		log.debug("roles = {}",roles);
//		member.setAuthorities(roles);
//		Authentication newAuthentication = new UsernamePasswordAuthenticationToken(
//				member,
//				null,
//				roles
//		);		
//		SecurityContextHolder.getContext().setAuthentication(newAuthentication);
		
		Collection<? extends GrantedAuthority> oldAuthorities = member.getAuthorities();
		List<SimpleGrantedAuthority> roles = new ArrayList<>();
		for(GrantedAuthority auth : oldAuthorities) {
			SimpleGrantedAuthority simpleAuth = new SimpleGrantedAuthority(auth.getAuthority());//문자열로 인자처리
			roles.add(simpleAuth);
		}
		//log.debug("roles = {}",roles);
		member.setAuthorities(roles);
		Authentication newAuthentication = new UsernamePasswordAuthenticationToken(
				member,
				null,
				member.getAuthorities()
			);
		SecurityContextHolder.getContext().setAuthentication(newAuthentication);
	}
	
	/**
	 * 아이디 중복검사
	 */
	@GetMapping("/checkIdDuplicate2.do")
	@ResponseBody
	public Map<String,Object> checkIdDuplicate2(@RequestParam String id) {
		Map<String,Object> map = new HashMap<>();
		try {
			//1. 업무로직
			Member member = memberService.selectOneMember(id);
			boolean available = member == null;
			
			//2. map에 요소 저장후 리턴
			map.put("available", available);
			map.put("id", id);	
		} catch(Exception e) {
			log.error("회원아이디 중복검사 오류!",e);
			throw e;
		}
		return map; 
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
	 * 전화번호 중복검사
	 */
	@GetMapping("/checkPhoneDuplicate2.do")
	@ResponseBody
	public Map<String,Object> checkPhoneDuplicate2(@RequestParam String phone) {
		Map<String,Object> map = new HashMap<>();
		try {
			Member member = memberService.selectOneMemberByPhone(phone);
			boolean available = member == null;
			map.put("available", available);
			map.put("phone", phone);
		} catch(Exception e) {
			log.error("회원전화번호 중복검사 오류!",e);
			throw e;
		}
		return map;
	}
	
	/**
	 * 아이디찾기(휴대폰번호)
	 * @param phone
	 * @return
	 */
	@GetMapping("/memberIdSearch.do")
	@ResponseBody
	public Map<String,Object> memberIdSearch(@RequestParam String phone){
		log.debug("phone = {}", phone);
		Map<String,Object> map = new HashMap<>();
		boolean available = false;
		try {
			Member member = memberService.selectOneMemberByPhone(phone);
			if(member != null && member.getSso() == null) {
				available = true;
				log.debug("available = {}", available);
				//log.debug("memberId = {}",member.getId());
				map.put("id", member.getId());
			}else {
				log.debug("available = {}", available);
			}
			
			map.put("result", available);
		
		} catch(Exception e) {
			log.error("회원 아이디찾기 오류!",e);
			throw e;
		}
		return map;
	}
	/**
	 * 비밀번호찾기 가입확인(이메일)
	 * @param email
	 * @return
	 */
	@GetMapping("/memberPwdSearch.do")
	@ResponseBody
	public Map<String,Object> memberPwdSearch(@RequestParam String email){
		log.debug("email = {}", email);
		Map<String,Object> map = new HashMap<>();
		boolean available = false;
		try {
			Member member = memberService.selectOneMemberByEmail(email);
			if(member != null && member.getSso() == null) {
				available = true;
				log.debug("available = {}", available);				
			}else {
				log.debug("available = {}", available);
			}
			map.put("result", available);
		} catch(Exception e) {
			log.error("회원 비밀번호찾기 오류!",e);
			throw e;
		}
		return map;
	}
	
	
	@GetMapping("/pwdSrchSendEmail.do")
	@ResponseBody
	public Map<String,Object> pwdSrchSendEmail(@RequestParam String email) throws Exception {
		log.debug("email = {}", email);
		String mailCode = mailInit.createCode();
		String subject = "[나홀로 나들이] 임시비밀번호 전송메일입니다.";
        String content = "임시비밀번호 [" + mailCode + "] 입니다.";
        String from = "baguson@gmail.com";
        String to = email;
        Map<String,Object> param = new HashMap<>();
        
        boolean available = false;
        try {
			Member member = memberService.selectOneMemberByEmail(email);
			//log.debug("member = {}", member);
			String encodedPassword = bcryptPasswordEncoder.encode(mailCode);
			member.setPassword(encodedPassword);
			int result = memberService.updateMember(member);
			if(result != 0) {
				MimeMessage mail = mailSender.createMimeMessage();
				MimeMessageHelper mailHelper = new MimeMessageHelper(mail,true,"UTF-8");
				mailHelper.setFrom(from);     
				mailHelper.setTo(to);
				mailHelper.setSubject(subject);
				mailHelper.setText(content);                
				mailSender.send(mail);				
			}
			available = true;
			param.put("result", available);
		} catch(Exception e) {
			log.error("회원 비밀번호찾기 오류!",e);
			throw e;
		}
		return param;
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

         //log.debug("set = {}",set);

         JSONObject result = coolsms.send(set); // 보내기&전송결과받기
         //log.debug("result = {}", result);
         Map<String,Object> map = new HashMap<>();
         int success_count = Integer.parseInt(String.valueOf(result.get("success_count")));
         //log.debug("success_count = {}", success_count);
         
         int error_count = Integer.parseInt(String.valueOf(result.get("error_count")));
         //log.debug("error_count = {}", error_count);
         
         if (success_count == 1) {
        	 log.info("문자전송 성공");
        	 map.put("result", true);
         } 
         else if(error_count == 1) {
           // 메시지 보내기 실패      
           log.info("문자전송 실패");
           log.debug("code = {}", result.get("code"));
           log.debug("message = {}", result.get("message"));
           map.put("result", false);
         }

         return map;	
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
		//log.debug("mailCode = {}", mailCode);
		
		String subject = "[나홀로 나들이] 인증 이메일입니다.";
        String content = "인증코드 [" + mailCode + "] 입니다.";
        String from = "baguson@gmail.com";
        String to = email;
		//log.debug("toEmail = {}", email);
		
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
	 * 네이버 로그인
	 * @param model
	 * @param code
	 * @param state
	 * @param session
	 * @return
	 * @throws IOException
	 * @throws ParseException
	 */
	@RequestMapping(value = "/naverCallback.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String naverCallback(Model model,  HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttr) throws IOException, ParseException {
		
		String code = request.getParameter("code");
		String state = request.getParameter("state");
		
		if(code == null || state == null) {
			return "redirect:/member/memberLogin.do";
			//return "redirect:/";
		}
		//log.debug("callback 메소드 호출");
		//log.debug("code = {}", code);
		//log.debug("state = {}", state);
		//log.debug("session = {}", session);
		try {
			/* 네아로 인증이 성공적으로 완료되면 code 파라미터가 전달되며 이를 통해 access token을 발급 */
			OAuth2AccessToken oauthToken = naverLoginBO.getAccessToken(session, code, state);
			/* 발급받은 AccessToken을 이용하여 현재 로그인한 네이버의 사용자 프로필 정보를 조회*/
			String apiResult = naverLoginBO.getUserProfile(oauthToken);
			//log.debug("apiResult = {}",apiResult);
			/**
			 * {
			 *  "resultcode":"00",
			 *  "message":"success",
			 *  "response":{
			 *  	"nickname" : "이재성",
			 *  	"id":"wMo2vw4Fv45mSPPy8-0ZLz3lZm2YlRE5R5ytHDYZBpg",
			 *  	"gender":"M",
			 *  	"email":"abc@naver.com",
			 *  	"mobile":"010-1234-1234",
			 *  	"mobile_e164":"+821012341234",
			 *  	"name":"\uc774\uc7ac\uc131"
			 *  }
			 * }
			 */
			
			//2. String형식인 apiResult를 json형태로 바꿈
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(apiResult);
			JSONObject jsonObj = (JSONObject) obj;
			//3. 데이터 파싱
			//JSONObject message_obj = (JSONObject)jsonObj.get("message");
			//String message = message_obj.toString();
			//log.debug("message = {}",message);
			
			//Top레벨 단계 _response 파싱
			JSONObject response_obj = (JSONObject)jsonObj.get("response");
			//response의 nickname값 파싱
			String nNickname = (String)response_obj.get("nickname");
			String nId = (String)response_obj.get("id");
			String nEmail = (String)response_obj.get("email");
			String nName = (String)response_obj.get("name");
			
			if(nEmail == null || "".equals(nEmail)) {
				model.addAttribute("warn", "정보제공에 모두 동의해주세요");
				if(!naverAuthUrl.contains("&auth_type=reprompt")) {
					naverAuthUrl += "&auth_type=reprompt";					
				}
				
				//log.debug("제공동의 x : naverAuthUrl = {}", naverAuthUrl);
				
				//String deleteTokenUrl = naverLoginBO.getDeleteToken();
				//deleteTokenUrl += oauthToken.getAccessToken();
				//log.debug("deleteTokenUrl = {}",deleteTokenUrl);
				model.addAttribute("naver_url", naverAuthUrl);
				//model.addAttribute("deleteTokenUrl", deleteTokenUrl);
				return "member/memberLogin";
			}
			
			
			Member member = new Member();
			if(nEmail != null && !"".equals(nEmail)) {
				//해당 이메일로 회원정보 조회후 로그인 처리후 메인으로 이동
				member = memberService.selectOneMemberByEmail(nEmail);
				//log.debug("member = {}",member);
				if(member == null) {
					//해당 사용자가 없다면 현재 로그인한 네이버 계정으로 회원가입이 가능하도록 가입페이지로 전달
					if(nNickname != null && !"".equals(nNickname))
						model.addAttribute("id", nNickname);
					if(nName != null && !"".equals(nName))
						model.addAttribute("name", nName);
					
					model.addAttribute("password", nId);
					model.addAttribute("email", nEmail);
					model.addAttribute("phone", "n1");
					model.addAttribute("sso", "naver");
					return "member/moreInfo";
				}
				
				if(member != null && !"naver".equals(member.getSso())) {
					//이미가입되있다면 연동 or 정보제공 철회
					redirectAttr.addFlashAttribute("failLogin", "이미 가입되어있는 계정메일입니다.");
					return "redirect:/";
				}
				
				
			}
			member = memberService.loadUserByUserEmail(member.getEmail());
			//해당 사용자가 있는경우 로그인처리 
			//현재 세션에 사용자 로그인 정보를 저장
			log.debug("naverLoginMember = {}",member);
	//		session.setAttribute("member", member);
						
			setAuthentication(member);
		} catch(Exception e) {
			log.error("네이버 로그인 오류!",e);
			throw e;
		}
		return "redirect:/";		

		
	}
	
		
	
	/**
	 * 구글 로그인
	 * @param model
	 * @param code
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	@RequestMapping(value = "/googleCallback.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String googleCallback(Model model, @RequestParam(value = "code") String authCode, RedirectAttributes redirectAttr) throws ServletException, IOException{
		//log.info("googleCallback");
		try {
			//HTTP Request를 위한 RestTemplate
			RestTemplate restTemplate = new RestTemplate();
			
			String gClientId = null;
			String gClientSecret = null;
	
			try{
				prop.load(new FileReader(resource.getFile()));
				gClientId = prop.getProperty("gclientId");
				gClientSecret = prop.getProperty("gclientSecret");
				//log.debug("gclientId = {}",gClientId);
				//log.debug("gclientSecret = {}", gClientSecret);
			}catch(IOException e){
				e.printStackTrace();
			}
	
			//Google OAuth Access Token 요청을 위한 파라미터 세팅
			GoogleOAuthRequest googleOAuthRequestParam = GoogleOAuthRequest
					.builder()
					.clientId(gClientId)
					.clientSecret(gClientSecret)
					.code(authCode)

					.redirectUri("http://www.nanatravel.r-e.kr/nana/member/googleCallback.do")
					.grantType("authorization_code").build();
	
			//.redirectUri("http://18.222.247.91:8080/nana/member/googleCallback.do")
			
			//JSON 파싱을 위한 기본값 세팅
			//요청시 파라미터는 스네이크 케이스로 세팅되므로 Object mapper에 미리 설정해준다.
			ObjectMapper mapper = new ObjectMapper();
			mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
			mapper.setSerializationInclusion(Include.NON_NULL);
	
			//AccessToken 발급 요청
			ResponseEntity<String> resultEntity = restTemplate.postForEntity("https://oauth2.googleapis.com/token", googleOAuthRequestParam, String.class);
	
			//Token Request
			GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
			});
	
			//ID Token만 추출 (사용자의 정보는 jwt로 인코딩 되어있다)
			String jwtToken = result.getIdToken();
			String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
			.queryParam("id_token", jwtToken).encode().toUriString();
			
			String resultJson = restTemplate.getForObject(requestUrl, String.class);
			
			Map<String,String> userInfo = mapper.readValue(resultJson, new TypeReference<Map<String, String>>(){});
			//log.debug("userInfo = {}",userInfo);
			//log.debug("token = {}",result.getAccessToken());
			/**
			 * userInfo = {
			 * 		iss=https://accounts.google.com, 
			 * 		azp=739408591416-eml5ffq3tmvluoslv9de803bfnha3mos.apps.googleusercontent.com, 
			 * 		aud=739408591416-eml5ffq3tmvluoslv9de803bfnha3mos.apps.googleusercontent.com, 
			 * 		sub=112698154223656739518, 
			 * 		email=baguson78@gmail.com, 
			 * 		email_verified=true, 
			 * 		at_hash=LpDd21V2S9Du8Br8GETFBw, 
			 * 		name=kane Harry, 
			 * 		picture=https://lh3.googleusercontent.com/a/AATXAJx4VvzmVi7fDyPEA0ZYH-LGcmedqT94KPuk0b7c=s96-c, 
			 * 		given_name=kane, 
			 * 		family_name=Harry, 
			 * 		locale=ko, 
			 * 		iat=1624352127, 
			 * 		exp=1624355727, 
			 * 		alg=RS256, 
			 * 		kid=112e4b52ab833017d385ce0d0b4c60587ed25842, 
			 * 		typ=JWT
			 * }
			 */
			
			//model.addAllAttributes(userInfo);
			//model.addAttribute("token", result.getAccessToken());
			String gemail = userInfo.get("email");
			String gname = userInfo.get("name");
			String gid = userInfo.get("kid");
			//log.debug("gemail = {}", gemail);
			//log.debug("gname = {}", gname);
			//log.debug("gid = {}", gid);
			
			if(gemail == null || "".equals(gemail)) {
				model.addAttribute("warn", "정보제공에 모두 동의해주세요");
				return "member/memberLogin";
			}
			
			Member member = new Member();
			if(gemail != null && !"".equals(gemail)) {
				member = memberService.selectOneMemberByEmail(gemail); //이메일로 db조회
				if(member == null) {
					//DB조회 후 가입되있지 않다면
					//추가항목 페이지로 이동
					model.addAttribute("email", gemail);
					model.addAttribute("password", gid); //고유키로 비번등록
					
					model.addAttribute("name", gname);
					model.addAttribute("phone", "g1");
					model.addAttribute("sso", "google");
					return "member/moreInfo";
				}
				if(member != null && !"google".equals(member.getSso())){
					redirectAttr.addFlashAttribute("failLogin", "이미 가입되어있는 계정메일입니다.");
					return "redirect:/";
				}
			}
			member = memberService.loadUserByUserEmail(member.getEmail());
			//db조회후 회원인경우 로그인처리
			log.debug("googleLoginMember = {}",member);
			setAuthentication(member);
		} catch(Exception e) {
			log.error("구글 로그인 오류!",e);
			throw e;
		}
		return "redirect:/";
	}
	
	
	/**
	 * 카카오 로그인
	 * @param model
	 * @param code
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/kakaoCallback.do", produces = "application/json", method = {RequestMethod.GET, RequestMethod.POST})
	public String kakaoCallback(Model model, @RequestParam("code") String code, HttpSession session, RedirectAttributes redirectAttr) throws Exception {
		try {
			//log.debug("code = {}",code);
			JsonNode node = KakaoController.getAccessToken(code);
			//log.debug("node = {}", node);
			JsonNode accessToken = node.get("access_token"); //accessToken에 사용자의 로그인한 모든 정보가 들어있음
			//log.debug("accessToken = {}", accessToken);
			
			JsonNode userInfo = KakaoController.getKakaoUserInfo(accessToken); //사용자의 정보
			//log.debug("userInfo = {}",userInfo);
	//		userInfo = {
	//		"id":1777393151,
	//		"connected_at":"2021-06-21T18:06:52Z",
	//		"properties":{"nickname":"baeguson78"},
	//		"kakao_account":{
	//			"profile_needs_agreement":false,
	//			"profile":{"nickname":"baeguson78",
	//					   "thumbnail_image_url":"http://k.kakaocdn.net/dn/dpk9l1/btqmGhA2lKL/Oz0wDuJn1YV2DIn92f6DVK/img_110x110.jpg",
	//					   "profile_image_url":"http://k.kakaocdn.net/dn/dpk9l1/btqmGhA2lKL/Oz0wDuJn1YV2DIn92f6DVK/img_640x640.jpg",
	//					   "is_default_image":true
	//			},
	//			"has_email":true,
	//			"email_needs_agreement":false,
	//			"is_email_valid":true,
	//			"is_email_verified":true,
	//			"email":"baguson78@gmail.com",
	//			"has_gender":false,
	//			"gender_needs_agreement":false 
	//		}
	//		}
			
//			if(accessToken == null) {
//				return "redirect:/";
//			}
			JsonNode kakao_account = userInfo.path("kakao_account");
			String kemail = kakao_account.path("email").asText(); //선택
			String id = userInfo.path("id").asText(); //카카오고유아이디		
			JsonNode profile = kakao_account.path("profile");
			String knickname = profile.path("nickname").asText(); //필수
			
			if(kemail == null || "".equals(kemail)) {
				model.addAttribute("warn", "정보제공에 모두 동의해주세요");
				return "member/memberLogin";
			}
			
			Member member = new Member();
//			Map<String,Object> param = new HashMap<>();
//			param.put("kemail", kemail);
//			param.put("sso", "kakao");
			
			if(kemail != null && !"".equals(kemail)) {
				member = memberService.selectOneMemberByEmail(kemail); //이메일로 db조회
				if(member == null) {
					//DB조회 후 가입되있지 않다면
					//추가항목 페이지로 이동
					if(kemail != null && !"".equals(kemail))
						model.addAttribute("email", kemail);
					if(id != null && !"".equals(id))
						model.addAttribute("password", id); //고유키로 비번등록
					
					model.addAttribute("id", knickname);
					model.addAttribute("phone", "k1");
					model.addAttribute("sso", "kakao");
					return "member/moreInfo";
				}
				if(member != null && !"kakao".equals(member.getSso())){
					redirectAttr.addFlashAttribute("failLogin", "이미 가입되어있는 계정메일입니다. 다른계정으로 로그인하세요.");
					return "redirect:/";
				}
			}
			member = memberService.loadUserByUserEmail(member.getEmail());
			//DB조회후 가입되있다면 바로 로그인처리 -> 홈으로 이동
			log.debug("kakaoLoginMember = {}",member);
			setAuthentication(member);
		
		} catch(Exception e) {
			log.error("카카오 로그인 오류!",e);
			throw e;
		}
		
		return "redirect:/";
	}
	
	
	
	
	/**
	 * 커맨드객체 이용시 사용자입력값(String)을 특정필드타입으로 변환할 editor객체를 설정
	 * 
	 * @param binder
	 */
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		//Member.birthday:java.sql.Date 타입 처리
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		//커스텀에디터 생성 : allowEmpty - true (빈문자열을 null로 변환처리 허용)
		PropertyEditor editor = new CustomDateEditor(sdf, true);
		binder.registerCustomEditor(java.sql.Date.class, editor);
	}
	
}
