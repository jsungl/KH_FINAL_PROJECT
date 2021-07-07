package com.kh.nana.noti.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.nana.member.model.vo.Member;
import com.kh.nana.noti.model.service.NotificationService;
import com.kh.nana.noti.model.vo.Notification;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NotificationController {

	@Autowired
	NotificationService notificationService;
	
	@GetMapping("/noti/myNoti.do")
	public void myNoti(Model model, Authentication authentication) {
		
		List<Notification> notiList = new ArrayList<>();
		
		Member principal = (Member)authentication.getPrincipal();
		String id = principal.getUsername();
		notiList = notificationService.selectAllNotification(id);
		
		log.debug("notiList = {}", notiList);
		
		if(notiList != null)
			model.addAttribute("notiList", notiList);
	}
	
	@ResponseBody
	@PostMapping("/noti/saveNoti.do")
	public String saveNoti(@RequestBody HashMap<String, String> map) {
		log.debug("saveNoti map = {}", map);
		int result = notificationService.saveNoti(map);
		if(result > 0)
			return "success";
		else
			return "error";
	}
	
	@PostMapping("/noti/deleteNoti.do")
	public String deleteNoti(@RequestParam int notiNo, RedirectAttributes redirectAttr) {
		log.debug("notiNo = {}", notiNo);
		int result = notificationService.deleteNoti(notiNo);
		if(result > 0)
			redirectAttr.addFlashAttribute("msg", "알림이 성공적으로 삭제되었습니다.");
		return "redirect:/noti/myNoti.do";
	}
	/*
	 * @MessageMapping("/notification/{id}")
	 * 
	 * @SendTo("/notification/{id}") public void sendMessage(@DestinationVariable
	 * String id) { log.debug("id = {}", id); log.debug("id = {}, alarm = {}", id,
	 * alarm);
	 * 
	 * //메세지 정보 DB에 담기
	 * 
	 * // /ask/admin으로도 메세지 보내기 simpMessagingTemplate.convertAndSend("/ask/admin",
	 * msg);
	 * 
	 * }
	 */

}
