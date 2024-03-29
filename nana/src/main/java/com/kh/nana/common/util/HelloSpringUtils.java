package com.kh.nana.common.util;

import java.io.FileReader;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import org.springframework.core.io.ClassPathResource;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class HelloSpringUtils {

	/**
	 * test.jpg
	 * 
	 * @param originalFilename
	 * @return
	 */
	public static String getRenamedFilename(String originalFilename) {
		//확장자 추출
		int beginIndex = originalFilename.lastIndexOf("."); // 4
		String ext = originalFilename.substring(beginIndex); // .jpg
		
		//년월일_난수 format
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
		DecimalFormat df = new DecimalFormat("000"); // 정수부 3자리
		
		return sdf.format(new Date()) + df.format(Math.random() * 1000) + ext;
	}

	/**
	 *  1. cPage 
	 *  2. limit 10
	 * 	3. totalContents 총 컨텐츠수
	 * 	4. url 이동할 주소 /spring/board/boardList.do
	 *  ----------------------------------------
	 * 	5. totalPage 전체페이지수 - pageNo 넘침 방지
	 * 	6. pageBarSize 페이지바에 표시할 페이지 개수 지정 : 5
	 * 	7. pageStart ~ pageEnd pageNo의 범위
	 * 	8. pageNo 페이지넘버를 출력할 증감변수
	 * 
	 * @param cPage
	 * @param numPerPage
	 * @param totalContents
	 * @param url
	 * @return
	 */
	public static String getPageBar(int totalContents, int cpage, int limit, String url) {
		StringBuilder pageBar = new StringBuilder();
		final int pageBarSize = 5;
		final int totalPage = (int) Math.ceil((double) totalContents / limit);
		final int pageStart = ((cpage - 1) / pageBarSize) * pageBarSize + 1; 
		final int pageEnd = pageStart + pageBarSize - 1;
		if(url.contains("placeNo")) {
			url += "&cpage=";
		}
		else {
			url += "?cpage=";
		}
		int pageNo = pageStart;
		
		pageBar.append("<nav aria-label=\"Page navigation example\">\r\n"
				+ "  <ul class=\"pagination justify-content-center\">");
		
		//1. 이전영역
		if(pageNo == 1) {
			//이전버튼 비활성화
			pageBar.append("  <li class=\"page-item disabled\">\r\n"
					+ "      <a class=\"page-link\" href=\"#\" aria-label=\"Previous\">\r\n"
					+ "        <span aria-hidden=\"true\">&laquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Previous</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		else {
			//이전버튼 활성화
			pageBar.append("  <li class=\"page-item\">\r\n"
					+ "      <a class=\"page-link\" href=\"" + url + (pageNo -1) + "\" aria-label=\"Previous\">\r\n"
					+ "        <span aria-hidden=\"true\">&laquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Previous</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		//2. pageNo영역
		while(pageNo <= pageEnd && pageNo <= totalPage) {
			if(pageNo == cpage) {
				//현재페이지 - 링크비활성화
				pageBar.append("<li class=\"page-item active\">\r\n"
						+ "      <a class=\"page-link\" href=\"#\">" + pageNo + "<span class=\"sr-only\">(current)</span></a>\r\n"
						+ "    </li>");
			}
			else {
				//현재페이지 아닌 경우 - 링크활성화
				pageBar.append(" <li class=\"page-item\"><a class=\"page-link\" href=\"" + url + pageNo + "\">" + pageNo + "</a></li>");
			}
			
			pageNo++;
		}
		
		//3. 다음영역
		if(pageNo > totalPage) {
			//다음버튼 비활성화
			pageBar.append("<li class=\"page-item disabled\">\r\n"
					+ "      <a class=\"page-link\" href=\"#\" aria-label=\"Next\">\r\n"
					+ "        <span aria-hidden=\"true\">&raquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Next</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		else {
			//다음버튼 활성화
			pageBar.append("<li class=\"page-item\">\r\n"
					+ "      <a class=\"page-link\" href=\"" + url + pageNo + "\" aria-label=\"Next\">\r\n"
					+ "        <span aria-hidden=\"true\">&raquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Next</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		
		pageBar.append("  </ul>\r\n"
				+ "</nav>");
		
		return pageBar.toString();
	}


	public static String getPageBarMypage(int totalContents, int cpage, int limit, String url, String id) {
		StringBuilder pageBar = new StringBuilder();
		final int pageBarSize = 5;
		final int totalPage = (int) Math.ceil((double) totalContents / limit);
		final int pageStart = ((cpage - 1) / pageBarSize) * pageBarSize + 1; 
		final int pageEnd = pageStart + pageBarSize - 1;
		url += "?cpage=";
		String plusId = "&id=";
		int pageNo = pageStart;
		
		pageBar.append("<nav aria-label=\"Page navigation example\">\r\n"
				+ "  <ul class=\"pagination justify-content-center\">");
		
		//1. 이전영역
		if(pageNo == 1) {
			//이전버튼 비활성화
			pageBar.append("  <li class=\"page-item disabled\">\r\n"
					+ "      <a class=\"page-link\" href=\"#\" aria-label=\"Previous\">\r\n"
					+ "        <span aria-hidden=\"true\">&laquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Previous</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		else {
			//이전버튼 활성화
			pageBar.append("  <li class=\"page-item\">\r\n"
					+ "      <a class=\"page-link\" href=\"" + url + (pageNo -1) + plusId + id + "\" aria-label=\"Previous\">\r\n"
					+ "        <span aria-hidden=\"true\">&laquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Previous</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		//2. pageNo영역
		while(pageNo <= pageEnd && pageNo <= totalPage) {
			if(pageNo == cpage) {
				//현재페이지 - 링크비활성화
				pageBar.append("<li class=\"page-item active\">\r\n"
						+ "      <a class=\"page-link\" href=\"#\">" + pageNo + "<span class=\"sr-only\">(current)</span></a>\r\n"
						+ "    </li>");
			}
			else {
				//현재페이지 아닌 경우 - 링크활성화
				pageBar.append(" <li class=\"page-item\"><a class=\"page-link\" href=\"" + url + pageNo + plusId + id + "\">" + pageNo + "</a></li>");
			}
			
			pageNo++;
		}
		
		//3. 다음영역
		if(pageNo > totalPage) {
			//다음버튼 비활성화
			pageBar.append("<li class=\"page-item disabled\">\r\n"
					+ "      <a class=\"page-link\" href=\"#\" aria-label=\"Next\">\r\n"
					+ "        <span aria-hidden=\"true\">&raquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Next</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		else {
			//다음버튼 활성화
			pageBar.append("<li class=\"page-item\">\r\n"
					+ "      <a class=\"page-link\" href=\"" + url + pageNo + plusId + id + "\" aria-label=\"Next\">\r\n"
					+ "        <span aria-hidden=\"true\">&raquo;</span>\r\n"
					+ "        <span class=\"sr-only\">Next</span>\r\n"
					+ "      </a>\r\n"
					+ "    </li>");
		}
		
		pageBar.append("  </ul>\r\n"
				+ "</nav>");
		
		return pageBar.toString();
	}
	
	
	public static String getApiKey(String fileName, String keyName) {
		//API 키 불러오기
		String apiKey = null;
		Properties prop = new Properties();
		
		//properties 파일 불러오기
		ClassPathResource resource = new ClassPathResource(fileName);
		try {
			prop.load(new FileReader(resource.getFile()));
			apiKey = prop.getProperty(keyName);
		} catch (IOException e) {
			log.error("프로퍼티 읽어오기 실패!", e);
		}
		return apiKey;
	}
	
	/**
	 * html 코드 제거
	 */
	public static String removeTag(String html) {
		return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}
	

}
