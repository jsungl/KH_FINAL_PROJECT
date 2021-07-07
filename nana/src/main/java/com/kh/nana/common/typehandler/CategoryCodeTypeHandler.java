package com.kh.nana.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import com.kh.nana.place.model.vo.CategoryCode;

public class CategoryCodeTypeHandler extends BaseTypeHandler<CategoryCode> {

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, CategoryCode parameter, JdbcType jdbcType)
			throws SQLException {
		ps.setString(i, parameter.getValue());
		
	}

	@Override
	public CategoryCode getNullableResult(ResultSet rs, String columnName) throws SQLException {
		// TODO Auto-generated method stub
		return CategoryCode.categoryCodeValueOf(rs.getString(columnName));
	}

	@Override
	public CategoryCode getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return CategoryCode.categoryCodeValueOf(rs.getString(columnIndex));
	}

	@Override
	public CategoryCode getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return CategoryCode.categoryCodeValueOf(cs.getString(columnIndex));
	}

}
