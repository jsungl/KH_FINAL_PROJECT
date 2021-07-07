<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/button.css" />
<style>
tr[data-id]{
	cursor:pointer;
}
</style>


<div class="container">
		<ul class="nav nav-pills" id="admin-pills">
			<li class="nav-item">
		    	<a class="nav-link" href="${pageContext.request.contextPath}/admin/adminManagement.do">관리자 홈</a>
		  	</li>
		  	<li class="nav-item">
		    	<a class="nav-link" href="${pageContext.request.contextPath}/admin/adminPlaceList.do">여행지관리</a>
		  	</li>
		  	<li class="nav-item">
		    	<a class="nav-link active" id="active" href="${pageContext.request.contextPath}/admin/memberList.do">회원관리</a>
		  	</li>
		</ul>
      	<h3 class="mt-5">회원목록</h3>
      	<table class="table mx-auto table-striped table-hover">
		    <tr>
		      <th scope="col">번호</th>
		      <th scope="col">ID</th>
		      <th scope="col">이름</th>
		      <th scope="col">가입일</th>
		      <th scope="col">삭제</th>
		    </tr>
			<c:if test="${not empty memberList}">
				<c:forEach var="member" items="${memberList}" varStatus="status">
				<c:set var="pageNum" value="${(page-1) * 10}"/>
					<tr data-id="${member.id}">
						<td scope="row"><c:out value="${status.count + pageNum}"/></td>
						<td>${member.id}</td>
						<td>${member.name}</td>
						<td>${member.enrollDate}</td>
						<td>
							<button class="btn btn-outline-danger" id="deleteBtn" onclick="deleteMember();" data-id="${member.id}" data-name="${member.name}">삭제</button>
						</td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
		${memberPageBar}
		<form:form name="memberDelFrm" action="${pageContext.request.contextPath}/admin/deleteMember.do" method="POST">
			<input type="hidden" name="memberId"/>
		</form:form>
</div>    
<script>
function deleteMember(){
	var id = $(event.target).data("id");
	var name = $(event.target).data("name");
	console.log(id);
	console.log(name);

	
	if(confirm(name + "님을 탈퇴처리하시겠습니까?")) {
		var $frm = $(document.memberDelFrm);
		$frm.find("[name=memberId]").val(id);
		$frm.submit();
	}

}

$("tr[data-id]").click(e => {
	console.log(e.target);
	if(e.target.id == "deleteBtn"){
		return false;
	}else{
		var $tr = $(e.target).parent();
		var id = $tr.data("id");
		location.href = "${pageContext.request.contextPath}/admin/memberDetail.do?id=" + id;
	} 
	
	
});


</script>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>