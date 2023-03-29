package com.memshelf.memshelf.presentation.view_models.login

import android.os.Bundle
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.*
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.memshelf.memshelf.presentation.view_models.home.HomeState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import java.lang.IllegalArgumentException
import javax.inject.Inject
import kotlin.reflect.KProperty


@HiltViewModel
class LoginViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    //Properties
    private val auth: FirebaseAuth = FirebaseAuth.getInstance()

    //Here were showing 2 different ways to declare state
    // state: email
    //By specifying private set, we're restricting writes to this state object to a private setter only visible inside the ViewModel.
    var email = mutableStateOf<String>("")
        private set

    // state: password
    //Here we're manually restricting writes to this state outside the ViewModel.
    private val _password = mutableStateOf<String>("")
    val password: State<String> = _password

    // state: loading
    //Here we're manually restricting writes to this state outside the ViewModel.
    private val _loading = mutableStateOf<Boolean>(false)
    val loading: State<Boolean> = _loading

    private val _eventFlow = MutableSharedFlow<LoginViewModel.UiEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    //Methods
    // event: onUpdateEmail is an event we're defining that the UI can invoke to change the value of email
    fun updateEmail(newEmail: String) {
        email.value = newEmail
    }

    // event: updatePassword is an event we're defining that the UI can invoke to change the value of password
    //Update password
    fun updatePassword(newPassword: String) {
        _password.value = newPassword
    }

    fun onEvent(event: LoginEvent) {
        when (event) {
            is LoginEvent.LogIn -> {
                if (_loading.value == false) {
                    val email: String =
                        email.value ?: throw IllegalArgumentException("email cannot be empty")
                    val password: String =
                        _password.value
                            ?: throw IllegalArgumentException("password cannot be empty")
                    _loading.value = true

                    auth.signInWithEmailAndPassword(email, password).addOnCompleteListener {
                        viewModelScope.launch {
                            if (it.isSuccessful) {
                                _eventFlow.emit(UiEvent.LogInUserSuccess)
                            } else {
                                _eventFlow.emit(
                                    UiEvent.ShowSnackbar(
                                        message = "Login Error. Try again."
                                    )
                                )
                                _loading.value = false
                            }
                        }
                    }
                }
            }
        }
    }


    sealed class UiEvent {
        data class ShowSnackbar(val message: String) : UiEvent()
        object LogInUserSuccess : UiEvent()
    }

}






