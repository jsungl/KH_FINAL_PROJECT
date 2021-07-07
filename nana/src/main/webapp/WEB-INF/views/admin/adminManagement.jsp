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

<div class="container mx-auto mt-3 mb-3 text-center">
<h2>관리자페이지</h2>
<br />
<br />
<br />
<button type="button" class="btn btn-outline-primary btn-lg mb-2" id="placeManageBtn" style="width:40%;">여행지관리</button> <br>
<button type="button" class="btn btn-outline-success btn-lg mb-2" id="memberManageBtn" style="width:40%;">회원관리</button> <br>
<button type="button" class="btn btn-outline-warning btn-lg mb-2" id="chatManageBtn" style="width:40%;">채팅관리</button>

</div>

<script>

$("#placeManageBtn").click(e => {
	location.href = "${pageContext.request.contextPath}/admin/adminPlaceList.do";
});

$("#memberManageBtn").click(e => {
	location.href = "${pageContext.request.contextPath}/admin/memberList.do";
});

$("#chatManageBtn").click(e => {
	location.href = "${pageContext.request.contextPath}/admin/adminChatList.do";
});


</script>

<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>