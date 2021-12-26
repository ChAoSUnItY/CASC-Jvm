package org.casc.lang.ast

import org.casc.lang.table.Reference

data class Class(
    val packageReference: Reference?,
    val usages: List<Reference?>,
    val accessorToken: Token?,
    val classKeyword: Token?,
    val name: Token?,
    var functions: List<Function>,
    val accessor: Accessor = Accessor.fromString(accessorToken?.literal)
)
