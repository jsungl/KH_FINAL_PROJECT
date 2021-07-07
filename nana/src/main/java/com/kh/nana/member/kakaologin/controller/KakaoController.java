package com.kh.nana.member.kakaologin.controller;

import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class KakaoController {
	
	//카카오로그인

	//private final static String K_CLIENT_ID = "3fad567e2e3ae320090c7aff0ad8b859";
//	private final static String K_REDIRECT_URI = "http://localhost:9090/nana/member/kakaoCallback.do";

	private final static String K_REDIRECT_URI = "http://www.nanatravel.r-e.kr/nana/member/kakaoCallback.do";
	//private final static String K_REDIRECT_URI = "http://18.222.247.91:8080/nana/member/kakaoCallback.do";

	
	private static String K_CLIENT_ID = null;
	
	public KakaoController() {
		try {
			ClassPathResource resource = new ClassPathResource("apikeys.properties");
			
			Properties prop = new Properties();
			try{
				prop.load(new FileReader(resource.getFile()));
				K_CLIENT_ID = prop.getProperty("kclientId");
				log.debug("kclientId = {}",K_CLIENT_ID);
			}catch(IOException e){
				e.printStackTrace();
			}
		
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	
	
	public static String getAuthorizationUrl(HttpSession session) { 
		String kakaoUrl = "https://kauth.kakao.com/oauth/authorize?" 
						+ "client_id=" 
						+ K_CLIENT_ID 
						+ "&redirect_uri=" 
						+ K_REDIRECT_URI 
						+ "&response_type=code";
		return kakaoUrl;
	}

	//public String getAccessToken(String autorize_code)
	//public static JsonNode getAccessToken(String autorize_code){}
	public static JsonNode getAccessToken(String autorize_code) { 
		final String RequestUrl = "https://kauth.kakao.com/oauth/token"; 
		final List<NameValuePair> postParams = new ArrayList<NameValuePair>(); 
		postParams.add(new BasicNameValuePair("grant_type", "authorization_code")); 
		postParams.add(new BasicNameValuePair("client_id", K_CLIENT_ID)); // REST API KEY 
		postParams.add(new BasicNameValuePair("redirect_uri", K_REDIRECT_URI)); // 리다이렉트 URI 
		postParams.add(new BasicNameValuePair("code", autorize_code)); // 로그인 과정중 얻은 code 값 
		
		final HttpClient client = HttpClientBuilder.create().build(); 
		final HttpPost post = new HttpPost(RequestUrl); 
		JsonNode returnNode = null; 
		try { 
			post.setEntity(new UrlEncodedFormEntity(postParams)); 
			final HttpResponse response = client.execute(post);
			//final int responseCode = response.getStatusLine().getStatusCode();/////////
			// JSON 형태 반환값 처리 
			ObjectMapper mapper = new ObjectMapper(); 
			returnNode = mapper.readTree(response.getEntity().getContent());
		} catch (UnsupportedEncodingException e) { 
			e.printStackTrace();
		} catch (ClientProtocolException e) { 
			e.printStackTrace(); 
		} catch (IOException e) { 
			e.printStackTrace(); 
		} finally { 
			// clear resources
		} 
		
		//returnNode.get("access_token").toString();
		return returnNode;
	}
	
	//public JsonNode getKakaoUserInfo(String autorize_code)
	public static JsonNode getKakaoUserInfo(JsonNode accessToken) { 
		final String RequestUrl = "https://kapi.kakao.com/v2/user/me"; 
		final HttpClient client = HttpClientBuilder.create().build(); 
		final HttpPost post = new HttpPost(RequestUrl); 
		//String accessToken = getAccessToken(autorize_code);
		// add header 
		post.addHeader("Authorization", "Bearer " + accessToken); 
		JsonNode returnNode = null; 
		try { 
			final HttpResponse response = client.execute(post); 
			//final int responseCode = response.getStatusLine().getStatusCode();
			// JSON 형태 반환값 처리 
			ObjectMapper mapper = new ObjectMapper(); 
			returnNode = mapper.readTree(response.getEntity().getContent());
		} catch (ClientProtocolException e) { 
			e.printStackTrace(); 
		} catch (IOException e) { 
			e.printStackTrace();
		} finally { 
			// clear resources
		}
		return returnNode;
	}
		
	


	
}
