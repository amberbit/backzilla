Backzilla
=========

Summary
=======
Backzilla is a multi-purpose backup tool based on duplicity - 'Encrypted bandwidth-efficient backup using the rsync algorithm' (http://duplicity.nongnu.org).

It can backup multiple entities (for example: MySQL database, directory, etc) to multiple destinations (for example: FTP, directory, etc). For ease of use, entities are groupped into 'projects'. This allows to manually backup/restore the whole project at once or one of its entities. Each entity knows how to restore itself from the backup destination. Projects and backup stores are configured using YAML files (look in /examples). Thanks to duplicity encryption, you can safely store your backups even in a public location. ;)

Usage
=====
No gem available currently, so:

    git clone git://github.com/amberbit/backzilla.git

Backzilla will look for ~/.backzilla/projects.yaml and ~/.backzilla/stores.yaml files. Just copy from /examples and customize. Be sure to generate your own GNU PGP passphrase and put it to stores.yaml.

To backup all entities:

    backzilla/bin/backzilla -b all

To backup a whole project or single entity:

    backzilla/bin/backzilla -b project_name[:entity_name]

Current state aka TODOs
=======================
Backup part is generally done. Needs some polishing and specs. Restore isn't implemented completely. Probably the script should also catch CTRL+C or any other interruptions and perform some wise cleanup.

- -m switch - move project_name to new_project_name or project_name:entity_name to new_project_name:new_entity_name in all stores
- always backup ~/.backzilla too
- allow projects nesting, eg
    client1:
      cit:
        entity1:
          ...
        entity2:
          ...
      loc:
        entity4:
          ...
      www:
        entity3:
          ...
    client2:
      proj1:
        entity1:
          ...
  in such case amberbit-www entity3 would be accessed like this amberbit:www:entity3
- -rm BACKUP_PATH - removes this backup from all stores
- if not present, sample config files should be created
- add more entity types
- add more store types

Supported entity types
======================
- MySQL
- MongoDB
- Directory

Supported store types
=====================
- FTP
- SSH
- Directory

Credits
-------
backzilla is maintained by [Wojciech Piekutowski](http://piekutowski.net), Paweł Sobolewski and is funded by [AmberBit](http://amberbit.com).

