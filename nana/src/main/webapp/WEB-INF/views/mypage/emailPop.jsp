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
<h2>이메일 수정</h2>
</div>

<div id="enroll-container" class="mx-auto mt-4 mb-4 text-center">
	<form:form name="memberEnrollFrm"
		action="${pageContext.request.contextPath}/mypage/memberUpdate.do"
		method="post">
		<table class="mx-auto mb-4">
			<input type="hidden" name="id" value="${principal.id}" />

			<tr>
				<th>E-mail</th>
				<td>
					<div id="memberEmail-container">
						<input type="email" class="form-control" placeholder="abc@xyz.com"
							name="email" id="email" required style="margin-bottom: 0; width: 320px;">
						<span class="guide ok" id="emailOk">이 이메일은 사용가능합니다.</span> <span
							class="guide error" id="emailError">이미 가입되있는 이메일입니다.</span>
					</div>
				</td>
				<td>
					<button class="btn btn-primary btn-sm" type="button"
						name="emailVerifyBtn" id="emailVerifyBtn"
						style="background-color: #ce8832; border-color: #d39e34;">인증메일
						전송</button>
				</td>
			</tr>
			<tr>
				<th></th>
				<td><input type="text" class="form-control"
					placeholder="인증번호 입력" name="emailVerifyNum" id="emailVerifyNum">
					<input type="hidden" name="emailVerifyCode" id="emailVerifyCode"
					value="0" /> <input type="hidden" id="emailValid" value="0" /> <input
					type="hidden" id="emailVerifyChk" value="0" /></td>
			</tr>

		</table>
		<input type="submit" class="btn btn-primary btn-lg" value="수정"
			style="width: 30%">
		<input type="reset" class="btn btn-secondary btn-lg" id="cancelBtn"
			value="취소" style="width: 30%">
	</form:form>
</div>

<script>

$("#cancelBtn").click(e => {
	//location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberLogin.do') ? pageContext.request.contextPath : header.referer}';
	location.href = '${header.referer}';
	//location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
});


//이메일 인증버튼 클릭
$("#emailVerifyBtn").click(e => {
	const email = $("#email").val();
	const $emailVerifyCode = $("#emailVerifyCode");
	
	if($("#emailValid").val() == 1){
		
		$.ajax({
			url: "${pageContext.request.contextPath}/mypage/sendEmail.do",
			data: {email},
			success: (data) => {
				console.log(data); //{"available" : true}
				const {result} = data;
				const {mailCode} = data;
				if(result){
					alert("인증메일이 전송되었습니다. 확인 후 인증코드를 입력해주세요.");
					$emailVerifyCode.val(mailCode);
				}else{
					alert("메일전송에 실패하였습니다.");
					$emailVerifyCode.val(0);
				}
			},
			error: console.log
		});
		
	}else{
		if(email.length < 4 || email.indexOf("@") === -1){
			alert("이메일을 입력해주세요");
			return;
		}
		alert("가입되있는 이메일입니다. 다시 입력해주세요");
	}



	
});

//이메일 인증코드 입력
$("#emailVerifyNum").keyup(e => {
	
	const emailVerifyNum = $(e.target).val();
	const emailVerifyCode = $("#emailVerifyCode").val();

	if(emailVerifyNum.length < 4){
		$("#emailVerifyChk").val(0);
		return;
	}

	if(emailVerifyNum == emailVerifyCode){
		$("#emailVerifyChk").val(1);
	}else{
		$("#emailVerifyChk").val(0);
	}

});



//이메일 입력
$("#email").keyup(e => {
	const email = $(e.target).val();
	const $emailError = $("#emailError");
	const $emailOk = $("#emailOk");
	const $emailValid = $("#emailValid");

	if(email.length < 4 || email.indexOf("@") === -1){
		$emailError.hide();
		$emailOk.hide();
		$emailValid.val(0); //다시 작성하는 경우 대비
		return;
	}

	$.ajax({
		url: "${pageContext.request.contextPath}/mypage/checkEmailDuplicate2.do",
		data: {email},
		success: (data) => {
			console.log(data); //{"available" : true}
			const {available} = data;
			if(available){
				$emailOk.show();
				$emailError.hide();
				$emailValid.val(1);
			}else{
				$emailOk.hide();
				$emailError.show();
				$emailValid.val(0);
			}
		},
		error: console.log
	});
	
});



//회원가입 폼 전송
$("[name=memberEnrollFrm]").submit(function(){

	var $emailValid = $("#emailValid");
	var $emailVerifyChk = $("#emailVerifyChk");
	var $email = $("#email");
	if($emailValid.val() == 0){
		alert("이메일 중복검사 해주세요");
		$email.focus();
		return false;
	}else if($emailVerifyChk.val() == 0){
		alert("이메일 인증번호가 일치하지않습니다");
		$emailVerifyChk.focus();
		return false;
	}

	
	return true;
});
</script>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>