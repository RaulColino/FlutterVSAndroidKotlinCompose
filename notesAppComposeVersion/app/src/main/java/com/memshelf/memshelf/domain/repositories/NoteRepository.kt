package com.memshelf.memshelf.domain.repositories

import com.memshelf.memshelf.domain.entities.Note
import kotlinx.coroutines.flow.Flow

interface NoteRepository {

    fun getNotes(): Flow<List<Note>>

    suspend fun getNoteById(id: Int): Note?

    suspend fun addNote(note: Note)

    suspend fun removeNote(note: Note)
}