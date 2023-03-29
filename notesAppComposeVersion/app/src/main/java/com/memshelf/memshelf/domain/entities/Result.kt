package com.memshelf.memshelf.domain.entities

sealed class Result<T>(
    val data: T? = null,
    val message: String? = null
){
    class Ok<T>(data: T?) : Result<T>(data)
    class Err<T>(message: String?, data: T? = null) : Result<T>(data,message)
    class Loading<T>(data: T? = null) : Result<T>(data)
}
