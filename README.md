# hexaa-migrator

hexaa migrator


## Creating new target database

```sql
CREATE DATABASE hexaa_new;
GRANT ALL PRIVILEGES ON `hexaa_new`.* TO 'hexaa'@'%'
```

## Link transformation


Old schema:

```plantuml
@startuml

Organization -- EntitlementPack

(Organization, EntitlementPack) .. organization_entitlement_pack

class organization_entitlement_pack {
    status
}

@enduml
```

New schema:

```plantuml
@startuml

Link --> Organization
Link --> Service

Link -- EntitlementPack
EntitlementPack --> Service

(Link, EntitlementPack) .. link_entitlement_pack

class Link {
    status
}

@enduml
```

**Note**:   The (`organization_id`,`service_id`) foreign key pair is a unique key in the Link table