package com.kh.nana.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import com.kh.nana.place.model.vo.LocaleCode;

public class LocaleCodeTypeHandler extends BaseTypeHandler<LocaleCode> {

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, LocaleCode parameter, JdbcType jdbcType)
			throws SQLException {
		ps.setString(i, parameter.getValue());
		
	}

	@Override
	public LocaleCode getNullableResult(ResultSet rs, String columnName) throws SQLException {
		// TODO Auto-generated method stub
		return LocaleCode.localeValueOf(rs.getString(columnName));
	}

	@Override
	public LocaleCode getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return LocaleCode.localeValueOf(rs.getString(columnIndex));
	}

	@Override
	public LocaleCode getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return LocaleCode.localeValueOf(cs.getString(columnIndex));
	}
	
	

}
