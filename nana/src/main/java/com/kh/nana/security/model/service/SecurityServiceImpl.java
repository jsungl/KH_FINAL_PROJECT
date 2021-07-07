package com.kh.nana.security.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.nana.security.model.dao.SecurityDao;

import lombok.extern.slf4j.Slf4j;

@Service("securityService")
@Slf4j
public class SecurityServiceImpl implements SecurityService {

	@Autowired
	private SecurityDao securityDao;
	
	
	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		UserDetails member = securityDao.loadUserByUsername(id); //id로 db에 접근하여 유저조회(비밀번호 맞는지 검사할필요없음 -> authentication-manager가 한다)
		log.debug("member = {}", member);
		if(member == null)
			throw new UsernameNotFoundException(id); //이 id로는 유저를 찾지못했습니다 오류 던짐
		return member;
	}

}
