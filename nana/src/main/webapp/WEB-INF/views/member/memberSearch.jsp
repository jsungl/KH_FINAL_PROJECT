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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberSearch.css" />


<div class="container">
<div id="Search-container" class="mx-auto mt-4 mb-4 text-center">
	<h2>아이디/비밀번호 찾기</h2> 
    <h6 style="color: red;">※SNS 계정 회원은 아이디/비밀번호 찾기가 불가능합니다※</h6>
    <div class="row">
        <div class="col"> 
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#idFind">아이디찾기</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#pwdFind">비밀번호 찾기</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="idFind">
                    <form name="memberIdSearchFrm">
                    	<table class="mx-auto mt-4 mb-4" style="width:80%;">
							<tr>
				                <th>휴대폰</th>
				                <td>	
				                    <input type="tel" class="form-control" placeholder="가입한 번호를 입력하세요. (-없이)01012345678" name="phone" id="phone" maxlength="11" required>
				                </td>
				                <td>
				                    <button class="btn btn-primary btn-sm" type="button" name="phoneVerifyBtn" id="phoneVerifyBtn">인증번호 전송</button>
				                </td>
				            </tr>
				            <tr>
				                <th></th>
				                <td>
					                <div id="memberPhone-container">
					                    <input type="text" class="form-control" placeholder="인증번호 입력" name="phoneVerifyNum" id="phoneVerifyNum">
					                    <span class="guide ok" id="phoneOk">일치</span>
								       	<span class="guide error" id="phoneError">불일치</span>
					                	<input type="hidden" name="phoneVerifyCode" id="phoneVerifyCode" value="0"/>
					                	<input type="hidden" name="phoneValid" id="phoneValid" value="0"/>
					                </div>
				                </td>
				            </tr>
							
						</table>
							<br />
							<br />
                    		<input type="submit" class="btn btn-primary btn-lg mx-auto" id="idSrchBtn" value="아이디찾기" style="width:30%;">
							<input type="reset" class="btn btn-secondary btn-lg mx-auto" id="idCancelBtn" value="취소" style="width:30%;">
                    	
                    </form>           
                </div>
                <div class="tab-pane fade" id="pwdFind">
                   <form name="memberPwdSearchFrm">
	                    <table class="mx-auto mt-4 mb-4" style="width:80%;">
							<tr>
				                <th>E-mail</th>
				                <td>
					                <div id="memberEmail-container">				               
					                    <input type="email" class="form-control" placeholder="가입한 이메일주소를 입력해주세요" name="email" id="email" required>	
					                    <span class="guide ok" id="emailOk">가입확인</span>
									    <span class="guide error" id="emailError">가입불확인</span>	
									    <input type="hidden" id="emailValid" value="0"/>			           
					                </div>
				                </td>
				                <td>
				                    <button class="btn btn-primary btn-sm" type="button" name="emailVerifyBtn" id="emailVerifyBtn">가입확인</button>     
				                </td>
				            </tr>
				            <tr>
				            	<th></th>
				            	<td class="text-center" style="color: red;">입력하신 이메일 주소로 임시비밀번호가 발송됩니다.</td>
				            </tr> 
						</table>
						<br />
						<br />
                   		<input type="submit" class="btn btn-primary btn-lg mx-auto" id="pwdSrchBtn" value="이메일전송" style="width:30%;">
						<input type="reset" class="btn btn-secondary btn-lg mx-auto" id="pwdCancelBtn" value="취소" style="width:30%;">
                   </form>
                </div>
            </div>
        </div>
    </div> 

</div>
</div>
<script>

$("#idCancelBtn").click(e => {
	//location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberLogin.do') ? pageContext.request.contextPath : header.referer}';
	location.href = '${header.referer}';
	//location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
	
});
$("#pwdCancelBtn").click(e => {
	//location.href = '${empty header.referer || fn:contains(header.referer, '/member/memberLogin.do') ? pageContext.request.contextPath : header.referer}';
	location.href = '${header.referer}';
	//location.href = "${pageContext.request.contextPath}/member/memberLogin.do";
	
});


//이메일 입력
$("#email").keyup(e => {
	
	const email = $(e.target).val();
	const $error = $("#phoneError");
	const $ok = $("#phoneOk");

	if(email.length < 4 || email.indexOf("@") === -1){
		$("#emailValid").val(0);
		$error.hide();
		$ok.hide();
		return;
	}
	
});

//이메일 인증버튼 클릭
$("#emailVerifyBtn").click(e => {

	const email = $("#email").val();
	const $emailValid = $("#emailValid");
	const $error = $("#emailError");
	const $ok = $("#emailOk");


	if(emailValid == 0){
		alert("이메일을 정확히 입력해주세요");	
		$emailValid.val(0);
		return;
	}else{
		
		$.ajax({
			url: "${pageContext.request.contextPath}/member/memberPwdSearch.do",
			data: {email},
			success: (data) => {
				console.log(data);
				const {result} = data;
				//const {id} = data;
				if(result){
					alert("가입되어있는 메일입니다. 이메일발송 버튼을 눌러주세요.");
					$emailValid.val(1);
				}else{
					alert("가입되어 있지않거나 SNS계정회원입니다.");
					$emailValid.val(0);
				}
			},
			error: console.log,
			complete(){
				if($emailValid.val() == 1){
					$ok.show();
					$error.hide();
				}
			}
		});
		
	}

});


//핸드폰 인증번호 입력
$("#phoneVerifyNum").keyup(e => {
	const phoneVerifyNum = $(e.target).val();
	const phoneVerifyCode = $("#phoneVerifyCode").val();
	const $error = $("#phoneError");
	const $ok = $("#phoneOk");

	if(phoneVerifyNum.length < 4){
		$("#phoneValid").val(0);
		$error.hide();
		$ok.hide();
		return;
	}

	if(phoneVerifyCode != 0){

		if(phoneVerifyNum == phoneVerifyCode){
			$ok.show();
			$error.hide();
			$("#phoneValid").val(1);
		}else{
			$ok.hide();
			$error.show();
			$("#phoneValid").val(0);
		}

	}else{
		alert("전화번호 입력후 전송버튼을 눌러주세요");
	}

	
});

//핸드폰 인증버튼 클릭
$("#phoneVerifyBtn").click(e => {

	 var number = Math.floor(Math.random() * 100000) + 100000;
     if(number>100000){
        number = number - 10000;
     }
     console.log(number);
     
     $("#phoneVerifyCode").val(number);
	 const to = $("#phone").val();
	 const code = $("#phoneVerifyCode").val();
	 
	 if(to == "" || to == null){
		alert("전화번호 입력후 전송버튼을 눌러주세요");
		$("#phoneValid").val(0);
		$("#phoneVerifyCode").val(0);
	 }else{

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
					$("#phoneVerifyCode").val(0);
				}
			},
			error: console.log
		});
	 }

});



//비밀번호찾기 폼전송
$("[name=memberPwdSearchFrm]").submit(e => {
	e.preventDefault();
	const email = $("#email").val();
	var $emailValid = $("#emailValid");
	
	if($emailValid.val() == 0){
		alert("이메일로 가입확인 먼저해주세요.")
		$("#email").focus();
		return false;
	}else{

		$.ajax({
			url: "${pageContext.request.contextPath}/member/pwdSrchSendEmail.do",
			data: {email},
			success: (data) => {
				console.log(data);
				const {result} = data;
				if(result){
					alert("임시비밀번호가 메일로 전송되었습니다. 로그인후 비밀번호를 변경해주세요.");
				}else{
					alert("메일전송에 실패하였습니다.");
				}
			},
			error: console.log,
			complete(){
				$("#email").val("");
				$("#emailValid").val(0);
				$(".guide").hide();
			}
		});

		
	}
});



//아이디찾기 폼전송
$("[name=memberIdSearchFrm]").submit(e => {
	e.preventDefault();
	const phone = $("#phone").val();
	var $phoneValid = $("#phoneValid");
	var $phoneVerifyNum = $("#phoneVerifyNum");
	var $phoneVerifyCode = $("#phoneVerifyCode")
	if($phoneVerifyCode.val() == 0){
		alert("인증을 먼저 진행해주세요")
		return false;
	}else if($phoneValid.val() == 0){
		alert("인증번호가 일치하지않습니다. 다시 확인해주세요")
		$phoneVerifyNum.focus();
		return false;
	}

	$.ajax({
		url: "${pageContext.request.contextPath}/member/memberIdSearch.do",
		data: {phone},
		success: (data) => {
			console.log(data);
			const {result} = data;
			const {id} = data;
			if(result){
				alert("가입한 계정의 아이디는 [" + id +"]입니다.");
			}else{
				alert("가입되어 있지않거나 SNS계정회원입니다.");
			}
		},
		error: console.log,
		complete(){
			$("#phone").val("");
			$("#phoneVerifyNum").val("");
			$("#phoneVerifyCode").val(0);
			$("#phoneValid").val(0);
			$(".guide").hide();
		}
	});
	


	
});
</script>

<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>