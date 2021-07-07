<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title"/>
</jsp:include>

<sec:authentication property="principal.username" var="user_id" />

<style>
div#demo-container {
	width: 550px;
}
.img-container>img {
	height: 8vw;
	width: 8vw;
}
.uploadResult ul li {
	list-style: none;
	float: left;
	display: inline-block;
}
.btn.btn-danger {
	border-radius: 50%;
	float: right;
}
.filename {
	float: left;
}
.img-container {
	display: inline-block;
}
</style>


<h2 class="mt-3" style="text-align: center;">게시글 작성</h2><br>
<div style="width: 60%; margin: auto;">
	<form:form id="boardFrm" method="post" action="${pageContext.request.contextPath}/board/selectPlaceBoardForm.do">
		<select class="custom-select inline-block" name="category" id="board-category" required style="width: 20%;" disabled>
          <option value="info">정보공유</option>
		</select>
		<input type="text" name="title" class="inline-block" style="width: 75%;" placeholder="제목" required/>
		<br><br> 
		<textarea id="summernote" name="content"></textarea>
		<input type="hidden" name="id" value="<c:if test="${not empty user_id}">${user_id}</c:if>" />
		<br>
		
		<div id="list-wrapper" style="display: none;">
		<h5>나의 여행코스 선택</h5>
		<div id="courseList" class="border" style="height: 200px; overflow:auto;">
		<table class="table table-striped">
		  <thead>
		    <tr>
		      <th scope="col">선택</th>
		      <th scope="col">여행코스</th>
		      <th scope="col">날짜</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${courseList}" var="course">
		   <tr>
		      <td><input type="radio" name="courseNo" value="${course.courseNo}"/></td>
		      <td>${course.title}</td>
		      <td><fmt:formatDate value="${course.regDate}" pattern="yyyy/MM/dd"/></td>
		    </tr>
		  
		  </c:forEach>
		  </tbody>
		</table>
		</div>
		</div>
		<br>
		<div id="searchPlaceWrapper">
			<h5>게시글과 연관된 장소 선택</h5>
			<input type="search" id="searchPlace" class="form-control col-sm-8 d-inline mb-2" value="${placeName}" readonly/>
			<input type="hidden" name="placeNo" value="${placeNo}"/>
			<input type="hidden" name="category" value="info"/>
			<br>
		</div>
		<input type="hidden" name="courseNo" value="0"/>
		</form:form>
		<br>
		<input class="btn btn-warning mx-auto" id="subBtn" type="button" value="게시글 등록"/>
	
</div>


<script>
const id = "${user_id}";
console.log("id= ", id);


$(document).ready(function(){
	//summernote editer
	  $('#summernote').summernote({
        placeholder: '내용을 입력하세요.',
        tabsize: 2,
        height: 300
      });

		$("#subBtn").click(() => {
			const $boardFrm = $("#boardFrm");
			$boardFrm.submit();
		});
});
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
