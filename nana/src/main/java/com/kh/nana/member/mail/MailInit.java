package com.kh.nana.member.mail;

import java.util.Random;

import org.springframework.stereotype.Component;

@Component
public class MailInit {

	private String mailCode = "";
	
	public String createCode() {
		StringBuffer temp = new StringBuffer();
		Random rnd = new Random();
		for(int i = 0; i < 10; i++) {
			int rIndex = rnd.nextInt(3);
			switch (rIndex) {
			case 0:
				// a-z
				temp.append((char) ((int) (rnd.nextInt(26)) + 97));
				break;
			case 1:
				// A-Z
				temp.append((char) ((int) (rnd.nextInt(26)) + 65));
				break;
			case 2:
				// 0-9
				temp.append((rnd.nextInt(10)));
				break;
			}
		}
		mailCode = temp.toString();
		return mailCode;
    }
}
