package com.memshelf.memshelf.presentation.screens

import android.util.Patterns
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.google.firebase.auth.FirebaseUser
import com.memshelf.memshelf.presentation.utils.navigation.Screen
import com.memshelf.memshelf.presentation.view_models.NoteDetail.NoteDetailEvent
import com.memshelf.memshelf.presentation.view_models.login.LoginEvent
import com.memshelf.memshelf.presentation.view_models.login.LoginViewModel
import kotlinx.coroutines.flow.collectLatest


@Composable
fun LoginScreen(
    navController: NavController,
    viewModel: LoginViewModel = hiltViewModel()
) {
    val email by viewModel.email
    val password by viewModel.password
    val loading by viewModel.loading

    //to show snackbars
    val scaffoldState = rememberScaffoldState()

    val scope = rememberCoroutineScope()

    //for keyboard and fields UI interactions
    var focusManager = LocalFocusManager.current
    val isEmailValid by derivedStateOf {
        Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }
    val isPasswordValid by derivedStateOf {
        password.isNotEmpty()
    }

    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is LoginViewModel.UiEvent.ShowSnackbar -> {
                    scaffoldState.snackbarHostState.showSnackbar(
                        message = event.message
                    )
                }
                is LoginViewModel.UiEvent.LogInUserSuccess -> {
                    navController.navigate(Screen.HomeScreen.route)
                }
            }
        }
    }


    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier.fillMaxSize()
    ) {
        if (loading) {
            CircularProgressIndicator()
        }
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Top
        ) {
            Spacer(modifier = Modifier.height(150.dp))
            Text(
                text = "Login",
                fontWeight = FontWeight.Bold,
                fontSize = 30.sp,
                modifier = Modifier.padding(top = 20.dp)
            )
            Spacer(modifier = Modifier.height(20.dp))
            OutlinedTextField(
                value = email,
                onValueChange = { viewModel.updateEmail(it) },
                label = { Text("Email") },
                placeholder = { Text("put email here...") },
                singleLine = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Email,
                    imeAction = ImeAction.Next
                ),
                keyboardActions = KeyboardActions(onNext = {
                    focusManager.moveFocus(FocusDirection.Down)
                }),
                isError = isEmailValid
            )

            OutlinedTextField(
                value = password,
                onValueChange = { viewModel.updatePassword(it) },
                label = { Text("Password") },
                placeholder = { Text("put password here...") },
                singleLine = true,
                visualTransformation = PasswordVisualTransformation(),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Password,
                    imeAction = ImeAction.Done
                ),
                keyboardActions = KeyboardActions(onNext = {
                    focusManager.clearFocus()
                }),
                isError = isPasswordValid
            )
            Spacer(modifier = Modifier.height(20.dp))
            Button(
                onClick = { viewModel.onEvent(LoginEvent.LogIn)},
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(all = 20.dp),
                colors = ButtonDefaults.buttonColors(backgroundColor = Color.Black),
                enabled = isEmailValid && isPasswordValid
            ) {
                Text(
                    text = "Login",
                    color = Color.White
                )
            }
        }
    }

}

//@Composable
//fun LoginScreen(
//    navController: NavController,
//    viewModel: SignupViewModel = hiltViewModel()
//) {
//    var focusManager = LocalFocusManager.current
//
//    var email by remember {
//        mutableStateOf("")
//    }
//
//    var password by remember {
//        mutableStateOf("")
//    }
//
//    val isEmailValid by derivedStateOf {
//        Patterns.EMAIL_ADDRESS.matcher(email).matches()
//    }
//
//    val isPasswordValid by derivedStateOf {
//        password.isNotEmpty()
//    }
//
//    Column(
//        modifier = Modifier
//            .background(color = Color.White)
//            .fillMaxSize(),
//        horizontalAlignment = Alignment.CenterHorizontally,
//        verticalArrangement = Arrangement.Top
//    ){
//        Spacer(modifier = Modifier.height(150.dp))
//        Text(
//            text = "Login",
//            fontWeight = FontWeight.Bold,
//            fontSize = 30.sp,
//            modifier = Modifier.padding(top = 20.dp)
//        )
//        Spacer(modifier = Modifier.height(20.dp))
//        OutlinedTextField(
//            value = email,
//            onValueChange = {email = it},
//            label = {Text("Email")},
//            placeholder = { Text("put email here...")},
//            singleLine = true,
//            modifier = Modifier.fillMaxWidth().padding(horizontal = 20.dp),
//            keyboardOptions = KeyboardOptions(
//                keyboardType = KeyboardType.Email,
//                imeAction = ImeAction.Next
//            ),
//            keyboardActions = KeyboardActions(onNext = {
//                focusManager.moveFocus(FocusDirection.Down)
//            }),
//            isError = isEmailValid
//        )
//        Spacer(modifier = Modifier.height(20.dp))
//        OutlinedTextField(
//            value = password,
//            onValueChange = {password = it},
//            label = {Text("Password")},
//            placeholder = { Text("put password here...")},
//            singleLine = true,
//            visualTransformation = PasswordVisualTransformation(),
//            modifier = Modifier.fillMaxWidth().padding(horizontal = 20.dp),
//            keyboardOptions = KeyboardOptions(
//                keyboardType = KeyboardType.Password,
//                imeAction = ImeAction.Done
//            ),
//            keyboardActions = KeyboardActions(onNext = {
//                focusManager.clearFocus()
//            }
//            ),
//            isError = isPasswordValid
//        )
//        Spacer(modifier = Modifier.height(20.dp))
//        Button(
//            onClick ={
//                   authInstance.signInWithEmailAndPassword(email,password).addOnCompleteListener{
//                       val currentUser: FirebaseUser? = authInstance.currentUser
//                       if(it.isSuccessful && currentUser!=null){
//                           navController.navigate(
//                               Screen.HomeScreen.route + "?auth=${currentUser}"
//                           )
//                       }else{
//                           print("Login failed: "+currentUser.toString())
//                       }
//                   }
//            },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(all = 20.dp),
//            colors = ButtonDefaults.buttonColors(backgroundColor = Color.Black),
//            enabled = isEmailValid && isPasswordValid
//        ){
//            Text(
//                text = "Login",
//                color = Color.White
//            )
//        }
//        Spacer(modifier = Modifier.height(20.dp))
//        Button(
//            onClick = {},
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(all = 20.dp),
//            colors = ButtonDefaults.buttonColors(backgroundColor = Color.Black),
//        ){
//            Text(
//                text = "SignUp",
//                color = Color.White
//            )
//        }
//
//    }
//}


//@ExperimentalFoundationApi
//@Composable
//fun LoginScreen(
//    navController: NavController,
//    viewModel: LoginViewModel = hiltViewModel()
//) {
//    val state = viewModel.state.value
//    val scaffoldState = rememberScaffoldState()
//    val scope = rememberCoroutineScope()
//
//    Scaffold(
//
//    ) {
//
//        }
//    }
//}
