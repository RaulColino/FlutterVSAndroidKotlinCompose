package com.memshelf.memshelf.data.datasources.local_db_room

import androidx.room.*
import com.memshelf.memshelf.domain.entities.Note
import kotlinx.coroutines.flow.Flow

@Dao
interface NoteDao {

    @Query("SELECT * FROM note")
    fun getNotes(): Flow<List<Note>>

    //A suspending function is just a regular Kotlin function with an additional suspend modifier
    //which indicates that the function can suspend/resume the execution of a coroutine.
    //They are only allowed to be called from a coroutine or another suspend function.
    @Query("SELECT * FROM note WHERE id = :id")
    suspend fun getNoteById(id: Int) : Note?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertNote(note: Note)

    @Delete
    suspend fun deleteNote(note: Note)
}