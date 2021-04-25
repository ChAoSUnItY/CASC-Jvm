package io.github.chaosunity.casc.parsing.expression

import io.github.chaosunity.casc.parsing.`type`.Type
import io.github.chaosunity.casc.parsing.scope.FunctionSignature
import io.github.chaosunity.casc.parsing.statement.Statement

import java.util

class FunctionCall(val signature: FunctionSignature,
                   val arguments: util.List[Expression],
                   private val _owner: Type,
                   negative: Boolean) extends Expression(signature.returnType, negative) with Statement {
    def functionName: String = signature.name

    def owner: Option[Type] = Option.apply(_owner)
}
