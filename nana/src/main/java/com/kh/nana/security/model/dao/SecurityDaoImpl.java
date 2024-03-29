package com.kh.nana.security.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

@Repository
public class SecurityDaoImpl implements SecurityDao {
	
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public UserDetails loadUserByUsername(String id) {
		return session.selectOne("security.loadUserByUsername",id);
	}

}
