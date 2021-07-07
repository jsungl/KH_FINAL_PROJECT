<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberEnroll.css" />

<div id="enroll-header" class="mx-auto text-center" style="margin-top:50px;">
<h2>회원 정보 수정</h2>
</div>

<div id="enroll-container" class="mx-auto mt-4 mb-4 text-center">
	<form:form 
		name="memberEnrollFrm" 
		action="${pageContext.request.contextPath}/mypage/memberUpdate.do" 
		method="post">
		<table class="mx-auto mb-4">
		<input type="hidden" name="id" value="${principal.id}" />
		<c:if test="${empty principal.sso}">
			<tr id="showPwdFrm1">
				<th></th>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" onclick="showPwdFrm();">패스워드 변경</button>
                </td>
            </tr>
			<tr id="showPwdFrm2"></tr>
			<tr id="showPwdFrm3"></tr>
		</c:if>
			  
			<tr>
				<th>이름</th>
				<td>	
					<input type="text" class="form-control" name="name" id="name" value="${principal.name}" required>
				</td>
			</tr>
			
			<tr>
				<th>생년월일</th>
				<td>		
					<input type="date" class="form-control" name="birthday" id="birthday" value="${principal.birthday}"/>
				</td>
			</tr>
			 
		<c:if test="${empty principal.sso}">
			<tr id="showEFrm">
				<th></th>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" onclick="location.href='${pageContext.request.contextPath}/mypage/emailPop';">이메일 변경</button>
                </td>
            </tr>
		</c:if>    
            
            <tr id="showPFrm">
				<th></th>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" onclick="location.href='${pageContext.request.contextPath}/mypage/phonePop';">휴대폰 번호 변경</button>
                </td>
            </tr>
            
			<tr>
				<th>성별</th>
				<td>
					<div class="form-check form-check-inline">
						<input type="radio" class="form-check-input" name="gender" id="gender0" value="M" <c:if test="${principal.gender eq 'M'}">checked</c:if>>
						<label  class="form-check-label" for="gender0">남</label>&nbsp;
						<input type="radio" class="form-check-input" name="gender" id="gender1" value="F" <c:if test="${principal.gender eq 'F'}">checked</c:if>>
						<label  class="form-check-label" for="gender1">여</label>
					</div>
				</td>
			</tr>
			
			<tr>
				<th>테마 선호도</th>
				<td>
					<div class="form-check form-check-inline">
						<input type="checkbox" class="form-check-input" name="preference" id="preference0" value="랜드마크"><label class="form-check-label" for="preference0">랜드</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference1" value="레저스포츠"><label class="form-check-label" for="preference1">레저/스포츠</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference2" value="오락"><label class="form-check-label" for="preference2">오락</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference3" value="맛집"><label class="form-check-label" for="preference3">맛집</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference4" value="캠핑"><label class="form-check-label" for="preference4">캠핑/차박</label>&nbsp;
					</div>
				</td>
			</tr>
			
		</table>
		<input type="submit" class="btn btn-primary btn-lg" value="수정" style="width:30%">
		<input type="reset" class="btn btn-secondary btn-lg" id="cancelBtn" value="취소" style="width:30%">
	</form:form>
</div>

<script>

$(document).ready(function(){
	var preference0 = $('input:checkbox[id="preference0"]');
	var preference1 = $('input:checkbox[id="preference1"]');
	var preference2 = $('input:checkbox[id="preference2"]');
	var preference3 = $('input:checkbox[id="preference3"]');
	var preference4 = $('input:checkbox[id="preference4"]');
	var preferenceArr = [preference0, preference1, preference2, preference3, preference4];
	var arr = new Array();

	<c:forEach items="${principal.preference}" var="preference" varStatus="status">
	arr[${status.index}] = '${preference}';
	</c:forEach>

	for(var i = 0; i < arr.length; i++){
		for(var j = 0; j < preferenceArr.length; j++){
			if(arr[i] == preferenceArr[j].val()){
				preferenceArr[i].attr("checked", true);
			}
		}
	}
});


$("#cancelBtn").click(e => {
	location.href = "${pageContext.request.contextPath}/mypage/mypage";
});


function showPwdFrm(){
	$('#showPwdFrm1').remove();
	$('#showPwdFrm2').html('<th>패스워드</th><td>'
			+'<input type="password" class="form-control" name="password" id="password" required></td>');
	$('#showPwdFrm3').html('<th>패스워드확인</th><td>'
			+'<input type="password" class="form-control" id="passwordCheck" required></td>');
}


//회원가입 폼 전송
$("[name=memberEnrollFrm]").submit(function(){

	//비밀번호 확인
	var $passwordValid = $("#passwordValid");
	var $password = $("#password");
	if(/^\w{4,}$/.test($password.val()) == false) {
		alert("비밀번호는 최소 4자리이상(영문+숫자)이어야 합니다.");
		$password.focus();
		return false;
	}

	
	if($password.val() != $passwordCheck.val()){
		alert("비밀번호가 일치하지않습니다.");
		$password.focus();
		return false;
	}
	
	
	return true;
});
</script>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>