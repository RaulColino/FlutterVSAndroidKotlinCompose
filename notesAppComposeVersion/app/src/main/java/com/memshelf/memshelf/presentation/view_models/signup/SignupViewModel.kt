package com.memshelf.memshelf.presentation.view_models.signup

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import com.memshelf.memshelf.domain.usecases.AddNoteUseCase
import com.memshelf.memshelf.domain.usecases.GetNoteByIdUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class SignupViewModel @Inject constructor(
    private val signupUseCase: AddNoteUseCase,
    savedStateHandle: SavedStateHandle
) : ViewModel(){}