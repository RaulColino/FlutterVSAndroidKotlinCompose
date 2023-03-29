package com.memshelf.memshelf.presentation.view_models.home

import com.memshelf.memshelf.domain.entities.Note

data class HomeState(
    val notes: List<Note> = emptyList(),
)


