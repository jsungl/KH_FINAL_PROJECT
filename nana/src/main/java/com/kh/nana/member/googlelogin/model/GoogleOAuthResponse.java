package com.kh.nana.member.googlelogin.model;

import lombok.Data;

/**
 * 응답받을 모델
 */
@Data
public class GoogleOAuthResponse {
	private String accessToken;
	private String expiresIn;
	private String refreshToken;
	private String scope;
	private String tokenType;
	private String idToken;

}
