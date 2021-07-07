package com.kh.nana.error;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/error")
public class ErrorController {
	
	@GetMapping("/defaultError.do")
	public void defaultError() {
		
	}
	
	@GetMapping("/error400.do")
	public void error400() {
		
	}
	
	@GetMapping("/error404.do")
	public void error404() {
		
	}
	
	@GetMapping("/error500.do")
	public void error500() {
		
	}
}
