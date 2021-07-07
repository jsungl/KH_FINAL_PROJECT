package com.kh.nana.member.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.nana.member.model.vo.Member;

@Repository
public class MemberDaoImpl implements MemberDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public Member selectOneMember(String id) {
		return session.selectOne("member.selectOneMember", id);
	}

	@Override
	public Member selectOneMemberByEmail(String email) {
		return session.selectOne("member.selectOneMemberByEmail", email);
	}
	
	@Override
	public int insertMember(Member member) {
		return session.insert("member.insertMember",member);
	}


	@Override
	public Member loadUserByUserEmail(String email) {
		return session.selectOne("member.loadUserByUserEmail",email);
	}

	@Override
	public Member selectOneMemberByPhone(String phone) {
		return session.selectOne("member.selectOneMemberByPhone", phone);
	}

	@Override
	public int updateMember(Member member) {
		return session.update("member.updateMember",member);
	}

	@Override
	public int selectTotalMember() {
		return session.selectOne("member.selectTotalMember");
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> page) {
		int offset = (int)page.get("offset");
		int limit = (int)page.get("limit");
		RowBounds rowBounds = new RowBounds(offset, limit);
		return session.selectList("member.selectMemberList", null, rowBounds);
	}

	@Override
	public int deleteMember(String memberId) {
		return session.delete("member.deleteMember", memberId);
	}

	
}
