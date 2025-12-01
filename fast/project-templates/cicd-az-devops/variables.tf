/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "agent_config" {
  description = "Agent configuration."
  type = object({
    agent_name = optional(string, "Test Agent on GCP")
    image      = optional(string, "azp-agent")
    azp = object({
      instance = string
      pool     = string
      token    = string
    })
  })
}

variable "instance_config" {
  description = "Instance configuration."
  type = object({
    service_account = string
    zone            = optional(string, "b")
    vpc_config = object({
      network    = string
      subnetwork = string
    })
  })
  nullable = false
}

variable "location" {
  description = "Location used for regional resources."
  type        = string
  default     = "europe-west8"
}

variable "name" {
  description = "Prefix used for resource names."
  type        = string
  nullable    = true
  default     = "azd"
}

variable "project_id" {
  description = "Project id where resources will be created."
  type        = string
}
