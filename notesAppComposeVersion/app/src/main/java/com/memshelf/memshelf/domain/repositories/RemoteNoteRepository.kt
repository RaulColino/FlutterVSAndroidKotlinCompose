package com.memshelf.memshelf.domain.repositories

import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.entities.Result
import kotlinx.coroutines.flow.Flow

interface RemoteNoteRepository {

    fun getNotes(userId: String): Flow<List<Note>>

    suspend fun addNote(note: Note, userId: String)

    suspend fun updateNote(note: Note, userId: String)

    suspend fun removeNote(note: Note, userId: String)
}