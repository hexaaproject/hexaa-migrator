<?php

/*
 * Copyright 2019 MTA-SZTAKI.
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

namespace Hexaa\ApiBundle\Hook\MasterKeyHook;
use Hexaa\StorageBundle\Entity\Principal;

/**
 * hexaa2.0 migrator app
 */
class migratorMasterKey extends MasterKeyHook {

    public function runHook() {
        // Base string
        $controllerBase = "Hexaa\\ApiBundle\\Controller\\";
        //Controller strings
        $entitlementControllerString = $controllerBase . "EntitlementController::";
        $entitlementPackControllerString = $controllerBase . "EntitlementpackController::";
        $entitlementPackEntitlementControllerString = $controllerBase . "EntitlementpackEntitlementController::";
        $invitationControllerString = $controllerBase . "InvitationController::";
        $organizationChildControllerString = $controllerBase . "OrganizationChildController::";
        $organizationControllerString = $controllerBase . "OrganizationController::";
        $principalControllerString = $controllerBase . "PrincipalController::";
        $roleControllerString = $controllerBase . "RoleController::";
        $serviceChildControllerString = $controllerBase . "ServiceChildController::";

        $validActions = array(
            $entitlementPackControllerString . "getEntitlementpackTokenAction",
            $entitlementPackControllerString . "getServiceEntitlementpackAction",

            $entitlementPackEntitlementControllerString . "getEntitlementsAction",
            $entitlementControllerString . "getServiceEntitlementAction",

            $invitationControllerString . "getInvitationResendAction",
            $invitationControllerString . "getInvitationAction",

            $organizationControllerString . "getAction",

            $organizationChildControllerString . "cgetInvitationsAction",

            $roleControllerString . "getOrganizationRoleAction",

            $organizationChildControllerString . "getMembersAction",
            $organizationChildControllerString . "getEntitlementpacksTokenAction",
            $organizationChildControllerString . "cgetRolesAction",

            $principalControllerString . "getPrincipalSelfAction",

            $roleControllerString . "getRoleEntitlementAction",
            $roleControllerString . "getRolePrincipalAction",

            $serviceChildControllerString . "cgetEntitlementpacksAction",

            );

        return in_array($this->_controller, $validActions);
    }

}
