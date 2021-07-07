<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypage.css" />

<script>

function deleteMember(){
	if (confirm("정말로 회원 탈퇴를 하시겠습니까?") == true){
		alert("소셜 로그인 회원은 탈퇴 후 해당 소셜에서 저희 페이지의 연결을 끊어주십시오.");
	    document.location.href='${pageContext.request.contextPath}/mypage/memberDelete';
	}else{
	    return;
	}
}

</script>

<main>
	<section>

		<div class="container" id="profile">
			<div class="col-xs-12" id="my-title">
				<h5>마이페이지</h5>
			</div>
			<div class="col-xs-12 text-center" style="margin: 50px 0;">
				<div>
					<i class="fa fa-user-circle fa-5x"></i>
				</div>
				<div class="text-center">
					<div class="p-3">
						<span>안녕하세요 <span style="color: rgb(0, 104, 223);">${principal.name}</span>
							님
						</span>
					</div>
					<input type="button" class="vw" value="회원정보 변경" onclick="location.href='${pageContext.request.contextPath}/mypage/memberUpdateForm';"/>
					<input type="button" class="vw" value="여행코스 등록" onclick="location.href='${pageContext.request.contextPath}/mypage/courseForm';"/>
					<input type="button" class="vw" value="회원 탈퇴" onclick="deleteMember()"/>
				</div>
			</div>
		</div>

		<div class="container" id="category">
			<div class="row align-items-start text-center">
				<form class="col" name="activeFrm"
					action="${pageContext.request.contextPath}/mypage/mypageActive"
					method="get"
					onclick="activeSubmit()">
					<span class="vw">활동 기록</span>
				</form>
				<form class="col" name="travelFrm"
					action="${pageContext.request.contextPath}/mypage/mypageTravel"
					method="get"
					onclick="travelSubmit()">
					<span class="vw">여행코스</span>
				</form>
				<form class="col" name="likeFrm"
					action="${pageContext.request.contextPath}/mypage/mypageLike"
					method="get"
					onclick="likeSubmit()">
					<span class="vw">좋아요/찜</span>
				</form>
			</div>
		</div>

		<script>
		function activeSubmit(){
			$(document.activeFrm).submit();
		}
		
		function travelSubmit(){
			$(document.travelFrm).submit();
		}
		
		function likeSubmit(){
			$(document.likeFrm).submit();
		}
		</script>