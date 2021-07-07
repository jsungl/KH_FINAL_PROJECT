package com.kh.nana.member.model.vo;

import java.sql.Date;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Member implements UserDetails{

	private String id;
	private String password;
	private String name;
	private String gender;
	private Date birthday;
	private String email;
	private String phone;
	private String[] preference;
	private String sso;
	private Date enrollDate;
	
	//복수개의 권한을 관리
	//SimpleGrantedAuthority : 문자열 data("ROLE_USER","ROLE_ADMIN")를 처리할수있는 GrantedAuthority의 하위 클래스
	private List<SimpleGrantedAuthority> authorities;
	
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}
	@Override
	public String getUsername() {
		return id;
	}
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}
	
	
	@Override
	public boolean isEnabled() {
		return true;
	}
	
	
}
