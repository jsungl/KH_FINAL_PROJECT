<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>



<c:choose>
	<c:when test="${sso eq null}">
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>오류</title>
	</head>
		<body>
			<img src="${pageContext.request.contextPath}/resources/images/error-page.png" alt="에러" width="50" height="50"/>
			<h1 style="margin:0;">SNS계정으로 로그인해주세요.</h1>
			<a href="${pageContext.request.contextPath}">홈으로</a>
		</body>
	</html>			
	</c:when>
	<c:otherwise>
		<%-- header --%>
		<jsp:include page="/WEB-INF/views/common/header.jsp">
			<jsp:param value="나홀로 나들이" name="title" />
		</jsp:include>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberEnroll.css" />
	
	
	
		<div class="container text-center" style="margin-top:50px;margin-bottom:30px;">
			<h2>회원정보 추가 항목 입력</h2>
			<h6 style="color:red;">※ 추가항목을 입력해야 소셜계정으로 가입 및 로그인할 수 있습니다. ※</h6>	
			<%-- <div style="text-align:center">${result}</div> --%>
		</div>
		
		<div id="enroll-container" class="mx-auto mt-4 mb-4 text-center">
			<form:form 
				name="memberAddEnrollFrm" 
				action="${pageContext.request.contextPath}/member/moreInfo.do" 
				method="post">
				<table class="mx-auto mb-4">
					<tr>
						<th>아이디</th>
						<td>
					        <div id="memberId-container">
						        <c:choose>
									<c:when test="${not empty id}">
										<input type="text" class="form-control" name="id" id="id" value="${id}" required>
									</c:when>
									<c:when test="${empty id}">
										<input type="text" class="form-control" placeholder="아이디 (4글자이상)" name="id" id="id" required>
									</c:when>
								</c:choose>	
					            <span class="guide ok">이 아이디는 사용가능합니다.</span>
					            <span class="guide error">이 아이디는 사용할 수 없습니다.</span>
					            <input type="hidden" id="idValid" value="0"/>
					        </div>
					    </td>
						
					</tr>  
					<tr>
						<th>이름</th>
						<td>
							<c:choose>
								<c:when test="${not empty name}">
									<input type="text" class="form-control" name="name" id="name" value="${name}" required>
								</c:when>
								<c:when test="${empty name}">
									<input type="text" class="form-control" name="name" id="name" required>
								</c:when>
							</c:choose>		
						</td>
					</tr>
					<tr>
						<th>생년월일</th>
						<td>		
							<input type="date" class="form-control" name="birthday" id="birthday"/>
						</td>
					</tr> 
					<tr>
						<th>이메일</th>
						<td>
							<c:choose>
								<c:when test="${not empty email}">
									<input type="email" class="form-control" name="email" id="email" value="${email}" readonly>
								</c:when>
								<c:when test="${empty email}">
									<input type="email" class="form-control" placeholder="abc@xyz.com" name="email" id="email" required>
								</c:when>
							</c:choose>	
						</td>
					</tr>
					<tr>
						<th>성별</th>
						<td>
							<div class="form-check form-check-inline">
								<input type="radio" class="form-check-input" name="gender" id="gender0" value="M">
								<label  class="form-check-label" for="gender0">남</label>&nbsp;
								<input type="radio" class="form-check-input" name="gender" id="gender1" value="F">
								<label  class="form-check-label" for="gender1">여</label>
							</div>
						</td>
					</tr>
					<tr>
						<th>테마 선호도</th>
						<td>
							<div class="form-check form-check-inline">
								<input type="checkbox" class="form-check-input" name="preference" id="preference0" value="랜드마크"><label class="form-check-label" for="preference0">랜드마크</label>&nbsp;
								<input type="checkbox" class="form-check-input" name="preference" id="preference1" value="레저스포츠"><label class="form-check-label" for="preference1">레저/스포츠</label>&nbsp;
								<input type="checkbox" class="form-check-input" name="preference" id="preference2" value="오락"><label class="form-check-label" for="preference2">오락</label>&nbsp;
								<input type="checkbox" class="form-check-input" name="preference" id="preference3" value="맛집"><label class="form-check-label" for="preference3">맛집</label>&nbsp;
								<input type="checkbox" class="form-check-input" name="preference" id="preference4" value="캠핑"><label class="form-check-label" for="preference4">캠핑/차박</label>&nbsp;
							 </div>
						</td>
					</tr>
				</table>
				<input type="hidden" name="password" id="password" value="${password}"/>
				<input type="hidden" name="sso" id="sso" value="${sso}"/>
				<input type="hidden" name="phone" id="phone" value="${phone}"/>
				<input type="submit" class="btn btn-primary btn-lg" value="가입" style="width:30%;background-color:#f6bd3a; border-color:#d39e34;">
				<input type="reset" class="btn btn-secondary btn-lg" onclick="goHome();" value="취소" style="width:30%">
			</form:form>
		</div>
		<%-- footer --%>
		<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
	</c:otherwise>
</c:choose>


<script>

$(function() {
	const id = $("#id").val();
	const $error = $(".guide.error");
	const $ok = $(".guide.ok");
	const $idValid = $("#idValid");
	
    if($("#id").val() == ""){
       
    }else{
        
    	if(/^\w{4,}$/.test(id) == false) {
    		alert("아이디는 최소 4자리이상(영문+숫자)이어야 합니다.");
    		$("#id").focus();
    		return false;
    	}else{
    		$.ajax({
        		url: "${pageContext.request.contextPath}/member/checkIdDuplicate2.do",
        		data: {id},
        		success: (data) => {
        			console.log(data); //{"available" : true}
        			const {available} = data;
        			if(available){
        				$ok.show();
        				$error.hide();
        				$idValid.val(1);
        			}else{
        				$ok.hide();
        				$error.show();
        				$idValid.val(0);
        			}
        		},
        		error: console.log
        	});
        }
		
    	
    }

    return false;
});


function goHome(){
	location.href = "${pageContext.request.contextPath}";
	
}





$("#id").keyup(e => {
	const id = $(e.target).val();
	const $error = $(".guide.error");
	const $ok = $(".guide.ok");
	const $idValid = $("#idValid"); //0 -> 1(중복검사 성공시)

	if(id.length < 4){
		$(".guide").hide();
		$idValid.val(0); //다시 작성하는 경우 대비
		return;
	}
	
	//{id} => {id: "abcde"}
	$.ajax({
		url: "${pageContext.request.contextPath}/member/checkIdDuplicate2.do",
		data: {id},
		success: (data) => {
			console.log(data); //{"available" : true}
			const {available} = data;
			if(available){
				$ok.show();
				$error.hide();
				$idValid.val(1);
			}else{
				$ok.hide();
				$error.show();
				$idValid.val(0);
			}
		},
		error: console.log
	});
	
});


	
$("[name=memberAddEnrollFrm]").submit(function(){

	var $id = $("#id");
	if(/^\w{4,}$/.test($id.val()) == false) {
		alert("아이디는 최소 4자리이상(영문+숫자)이어야 합니다.");
		$id.focus();
		return false;
	}

	var $idValid = $("#idValid");
	if($idValid.val() == 0){
		alert("아이디 중복검사 해주세요");
		$id.focus();
		return false;
	}
	
	return true;
});
</script>	
	
	
	
	
<%-- footer --%>
<%-- <jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include> --%>