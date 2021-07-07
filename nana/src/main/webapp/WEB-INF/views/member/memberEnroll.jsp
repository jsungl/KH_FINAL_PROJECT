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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberEnroll.css" />

<div id="enroll-header" class="mx-auto text-center" style="margin-top:50px;">
<h2>회원가입</h2>
</div>

<div id="enroll-container" class="mx-auto mt-4 mb-4 text-center">
	<form:form 
		name="memberEnrollFrm" 
		action="${pageContext.request.contextPath}/member/memberEnroll.do" 
		method="post">
		<table class="mx-auto mb-4">
			<tr>
				<th>아이디</th>
				<td>
			        <div id="memberId-container">
			            <input type="text" class="form-control" placeholder="아이디 (4글자이상)" name="id" id="id" required>
			            <span class="guide ok" id="idOk">이 아이디는 사용가능합니다.</span>
			            <span class="guide error" id="idError">이 아이디는 사용할 수 없습니다.</span>
			            <input type="hidden" id="idValid" value="0"/>
			        </div>
			    </td>
			</tr>
			
			<tr>
				<th>패스워드</th>
				<td>
					<input type="password" class="form-control" name="password" id="password" required>
				</td>
			</tr>
			<tr>
				<th>패스워드확인</th>
				<td>	
					<input type="password" class="form-control" id="passwordCheck" required>
					<input type="hidden" id="passwordValid" value="0"/>
				</td>
			</tr>
			  
			<tr>
				<th>이름</th>
				<td>	
					<input type="text" class="form-control" name="name" id="name" required>
				</td>
			</tr>
			
			<tr>
				<th>생년월일</th>
				<td>		
					<input type="date" class="form-control" name="birthday" id="birthday"/>
				</td>
			</tr>
			 
			<tr>
                <th>E-mail</th>
                <td>
                	<div id="memberEmail-container">	
                    	<input type="email" class="form-control" placeholder="abc@xyz.com" name="email" id="email" required style="margin-bottom: 0;">
                		<span class="guide ok" id="emailOk">이 이메일은 사용가능합니다.</span>
			            <span class="guide error" id="emailError">이미 가입되있는 이메일입니다.</span>
                	</div>
                </td>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" name="emailVerifyBtn" id="emailVerifyBtn" style="background-color:#ce8832; border-color: #d39e34;">인증메일 전송</button>     
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <input type="text" class="form-control" placeholder="인증번호 입력" name="emailVerifyNum" id="emailVerifyNum">
                	<input type="hidden" name="emailVerifyCode" id="emailVerifyCode" value="0"/>
                	<input type="hidden" id="emailValid" value="0"/>
                	<input type="hidden" id="emailVerifyChk" value="0"/>
                </td>
            </tr>    
            
            <tr>
                <th>휴대폰</th>
                <td>
	                <div id="memberPhone-container">	
	                    <input type="tel" class="form-control" placeholder="(-없이)01012345678" name="phone" id="phone" maxlength="11" required style="margin-bottom: 0;">
	                    <span class="guide ok" id="phoneOk">이 번호는 사용가능합니다.</span>
			            <span class="guide error" id="phoneError">이미 가입되있는 번호입니다.</span>
	                </div>
                </td>
                <td>
                    <button class="btn btn-primary btn-sm" type="button" name="phoneVerifyBtn" id="phoneVerifyBtn" style="background-color:#ce8832; border-color: #d39e34;">인증번호 전송</button>
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <input type="text" class="form-control" placeholder="인증번호 입력" name="phoneVerifyNum" id="phoneVerifyNum">
                	<input type="hidden" name="phoneVerifyCode" id="phoneVerifyCode" value="0"/>
                	<input type="hidden" name="phoneValid" id="phoneValid" value="0"/>
                	<input type="hidden" name="phoneVerifyChk" id="phoneVerifyChk" value="0"/>                	
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
						<input type="checkbox" class="form-check-input" name="preference" id="preference0" value="랜드마크"><label class="form-check-label" for="preference0">랜드</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference1" value="레저스포츠"><label class="form-check-label" for="preference1">레저/스포츠</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference2" value="오락"><label class="form-check-label" for="preference2">오락</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference3" value="맛집"><label class="form-check-label" for="preference3">맛집</label>&nbsp;
						<input type="checkbox" class="form-check-input" name="preference" id="preference4" value="캠핑"><label class="form-check-label" for="preference4">캠핑/차박</label>&nbsp;
					 </div>
				</td>
			</tr>
			
		</table>
		<input type="submit" class="btn btn-primary btn-lg" value="가입" id="joinBtn" style="width:30%; background-color:#f6bd3a; border-color:#d39e34;">
		<input type="reset" class="btn btn-secondary btn-lg" id="cancelBtn" value="취소" style="width:30%;">
	</form:form>
</div>
<script>

$("#cancelBtn").click(e => {
	//location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberLogin.do') ? pageContext.request.contextPath : header.referer}';
	location.href = '${header.referer}';
	//location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
});


//이메일 인증번호버튼 클릭
$("#emailVerifyBtn").click(e => {
	const email = $("#email").val();
	const $emailVerifyCode = $("#emailVerifyCode");
	
	if($("#emailValid").val() == 1){
		
		$.ajax({
			url: "${pageContext.request.contextPath}/member/sendEmail.do",
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
		url: "${pageContext.request.contextPath}/member/checkEmailDuplicate2.do",
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


//휴대폰전화번호 입력
$("#phone").keyup(e => {
	const phone = $(e.target).val();
	const $phoneError = $("#phoneError");
	const $phoneOk = $("#phoneOk");
	const $phoneValid = $("#phoneValid");

	if(phone.length < 11){
		$phoneError.hide();
		$phoneOk.hide();
		$phoneValid.val(0); //다시 작성하는 경우 대비
		return;
	}

	$.ajax({
		url: "${pageContext.request.contextPath}/member/checkPhoneDuplicate2.do",
		data: {phone},
		success: (data) => {
			console.log(data);
			const {available} = data;
			if(available){
				$phoneOk.show();
				$phoneError.hide();
				$phoneValid.val(1);
			}else{
				$phoneOk.hide();
				$phoneError.show();
				$phoneValid.val(0);
			}
		},
		error: console.log
	});
	
});



//핸드폰 인증번호 입력
$("#phoneVerifyNum").keyup(e => {
	const phoneVerifyNum = $(e.target).val();
	const phoneVerifyCode = $("#phoneVerifyCode").val();

	if(phoneVerifyNum.length < 4){
		$("#phoneVerifyChk").val(0);
		return;
	}


	if(phoneVerifyNum == phoneVerifyCode){
		$("#phoneVerifyChk").val(1);
	}else{
		$("#phoneVerifyChk").val(0);
	}
	
});

//핸드폰 인증번호버튼 클릭
$("#phoneVerifyBtn").click(e => {

	 var number = Math.floor(Math.random() * 100000) + 100000;
     if(number>100000){
        number = number - 10000;
     }
     console.log(number);
     $("#phoneVerifyCode").val(number);
     
	 const to = $("#phone").val();
	 const code = $("#phoneVerifyCode").val();
	 const duplicateChk = $("#phoneValid").val();
	 
	 if(to == "" || to == null){
		alert("전화번호 입력후 전송버튼을 눌러주세요");
		$("#phoneVerifyChk").val(0);
		$("#phoneVerifyCode").val(0);
	 }else if(duplicateChk == 0) {
		alert("이미 가입되어있는 전화번호입니다. 다시확인해주세요.");
		$("#phoneVerifyChk").val(0);
		$("#phoneVerifyCode").val(0);
	}else {
		$.ajax({
			url: "${pageContext.request.contextPath}/member/sendSms.do",
			data: {to,code},
			success: (data) => {
				console.log(data);
				const {result} = data;
				if(result){
					alert("인증번호가 전송되었습니다. 확인후 입력해주세요(유효시간 30분)");
				}else{
					alert("인증번호 전송에 실패하였습니다.");
				}
			},
			error: console.log
		});
	 }

});


//아이디 입력
$("#id").keyup(e => {
	const id = $(e.target).val();
	const $ok = $("#idOk");
	const $error = $("#idError");
	const $idValid = $("#idValid"); //0 -> 1(중복검사 성공시)
	

	if(id.length < 4){
		$ok.hide();
		$error.hide();
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



//비밀번호 확인
$("#passwordCheck").blur(function(){
	var $password = $("#password");
	var $passwordCheck = $("#passwordCheck");
	var $passwordValid = $("#passwordValid");
	if($password.val() != $passwordCheck.val()){
		alert("패스워드가 일치하지 않습니다.");
		$password.select();
	}else{
		$passwordValid.val(1);
	}
});

//회원가입 폼 전송
$("[name=memberEnrollFrm]").submit(function(){

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

	//비밀번호 확인
	var $passwordValid = $("#passwordValid");
	var $password = $("#password");
	if(/^\w{4,}$/.test($password.val()) == false) {
		alert("비밀번호는 최소 4자리이상(영문+숫자)이어야 합니다.");
		$password.focus();
		return false;
	}

	
	if($passwordValid.val() == 0){
		alert("비밀번호가 일치하지않습니다.");
		$password.focus();
		return false;
	}

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

	var $phoneValid = $("#phoneValid");
	var $phoneVerifyNum = $("#phoneVerifyNum");
	var $phoneVerifyCode = $("#phoneVerifyCode");
	var $phoneVerifyChk = $("#phoneVerifyChk");
	if($phoneVerifyCode.val() == 0){
		alert("인증을 먼저 해주세요")
		return false;
	}else if($phoneVerifyChk.val() == 0){
		alert("인증번호가 일치하지않습니다. 다시 확인해주세요")
		$phoneVerifyNum.focus();
		return false;
	}
	
	
	
	return true;
});
</script>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>