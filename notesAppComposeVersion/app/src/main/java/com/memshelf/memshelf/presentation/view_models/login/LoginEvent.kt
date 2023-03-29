package com.memshelf.memshelf.presentation.view_models.login

import androidx.compose.ui.focus.FocusState

sealed class LoginEvent {

    object LogIn: LoginEvent()

}