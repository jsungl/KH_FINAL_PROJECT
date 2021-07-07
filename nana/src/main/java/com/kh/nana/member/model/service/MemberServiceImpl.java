package com.kh.nana.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.nana.member.model.dao.MemberDao;
import com.kh.nana.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberDao memberDao;

	@Override
	public Member selectOneMember(String id) {
		return memberDao.selectOneMember(id);
	}

	@Override
	public Member selectOneMemberByEmail(String email) {
		return memberDao.selectOneMemberByEmail(email);
	}
	
	@Override
	public int insertMember(Member member) {
		return memberDao.insertMember(member);
	}

	@Override
	public Member loadUserByUserEmail(String email) {
		Member member = memberDao.loadUserByUserEmail(email); 
		log.debug("member = {}", member);
		//if(member == null)
		//throw new Exception  
		return member;
	}

	@Override
	public Member selectOneMemberByPhone(String phone) {
		return memberDao.selectOneMemberByPhone(phone);
	}

	@Override
	public int updateMember(Member member) {
		return memberDao.updateMember(member);
	}

	@Override
	public int selectTotalMember() {
		return memberDao.selectTotalMember();
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> page) {
		return memberDao.selectMemberList(page);
	}

	@Override
	public int deleteMember(String memberId) {
		return memberDao.deleteMember(memberId);
	}

	
}
