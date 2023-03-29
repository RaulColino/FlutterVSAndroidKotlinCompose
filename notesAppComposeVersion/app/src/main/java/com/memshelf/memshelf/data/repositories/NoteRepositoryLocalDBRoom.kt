package com.memshelf.memshelf.data.repositories

import com.memshelf.memshelf.data.datasources.local_db_room.NoteDao
import com.memshelf.memshelf.domain.entities.Note
import com.memshelf.memshelf.domain.repositories.NoteRepository
import kotlinx.coroutines.flow.Flow

class NoteRepositoryLocalDBRoom(private val dao: NoteDao) : NoteRepository{

    override fun getNotes(): Flow<List<Note>> {
        return dao.getNotes()
    }

    override suspend fun getNoteById(id: Int): Note? {
        return dao.getNoteById(id)
    }

    override suspend fun addNote(note: Note) {
        return dao.insertNote(note)
    }

    override suspend fun removeNote(note: Note) {
        return dao.deleteNote(note)
    }
}