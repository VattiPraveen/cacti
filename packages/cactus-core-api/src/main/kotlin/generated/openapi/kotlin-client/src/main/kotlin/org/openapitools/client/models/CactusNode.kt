/**
 * Hyperledger Core API
 *
 * Contains/describes the core API types for Cactus. Does not describe actual endpoints on its own as this is left to the implementing plugins who can import and re-use commonly needed type definitions from this specification. One example of said commonly used type definitions would be the types related to consortium management, cactus nodes, ledgers, etc..
 *
 * The version of the OpenAPI document: 0.2.0
 * 
 *
 * Please note:
 * This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * Do not edit this file manually.
 */

@file:Suppress(
    "ArrayInDataClass",
    "EnumEntryName",
    "RemoveRedundantQualifierName",
    "UnusedImport"
)

package org.openapitools.client.models

import org.openapitools.client.models.CactusNodeAllOf
import org.openapitools.client.models.CactusNodeMeta

import com.squareup.moshi.Json

/**
 * A Cactus node can be a single server, or a set of servers behind a load balancer acting as one.
 *
 * @param nodeApiHost 
 * @param publicKeyPem The PEM encoded public key that was used to generate the JWS included in the response (the jws property)
 * @param id 
 * @param consortiumId 
 * @param memberId 
 * @param ledgerIds Stores an array of Ledger entity IDs that are reachable (routable) via this Cactus Node. This information is used by the client side SDK API client to figure out at runtime where to send API requests that are specific to a certain ledger such as requests to execute transactions.
 * @param pluginInstanceIds 
 */

data class CactusNode (

    @Json(name = "nodeApiHost")
    val nodeApiHost: kotlin.String,

    /* The PEM encoded public key that was used to generate the JWS included in the response (the jws property) */
    @Json(name = "publicKeyPem")
    val publicKeyPem: kotlin.String,

    @Json(name = "id")
    val id: kotlin.String,

    @Json(name = "consortiumId")
    val consortiumId: kotlin.String,

    @Json(name = "memberId")
    val memberId: kotlin.String,

    /* Stores an array of Ledger entity IDs that are reachable (routable) via this Cactus Node. This information is used by the client side SDK API client to figure out at runtime where to send API requests that are specific to a certain ledger such as requests to execute transactions. */
    @Json(name = "ledgerIds")
    val ledgerIds: kotlin.collections.List<kotlin.String> = arrayListOf(),

    @Json(name = "pluginInstanceIds")
    val pluginInstanceIds: kotlin.collections.List<kotlin.String> = arrayListOf()

)
