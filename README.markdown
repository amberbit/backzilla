Backzilla
=========

Summary
=======
Backzilla is a multi-purpose backup tool based on duplicity - 'Encrypted bandwidth-efficient backup using the rsync algorithm' (http://duplicity.nongnu.org).

It can backup multiple entities (for example: MySQL database, directory, etc) to multiple destinations (for example: FTP, directory, etc). For ease of use, entities are groupped into 'projects'. This allows to manually backup/restore the whole project at once or one of its entities. Each entity knows how to restore itself from the backup destination. Projects and backup stores are configured using YAML files (look in /examples). Thanks to duplicity encryption, you can safely store your backups even in a public location. ;)

Usage
=====
To install gem type:

    gem install backzilla

Backzilla will look for ~/.backzilla/projects.yaml and ~/.backzilla/stores.yaml files. You can copy them from /examples and customize for your oun purpose. Be sure to generate your own GNU PGP passphrase and put it to stores.yaml. It's basic of storing and restorign security of your backups.

To backup all entities:

    backzilla -b all

To backup a whole project or single entity:

    backzilla -b project_name[:entity_name]

To restore all entities:

    backzilla -r all

To backup a whole project or single entity:

    backzilla -r project_name[:entity_name]

To remove backups of given project from all stores:

    backzilla --remove project_name[:entity_name]

To remove all backups from all stores:

    backzilla --remove all

For other options type:

    backzilla -h

Current state aka TODOs
=======================
Backup and restore works correctly. Same goes with te rspec tests.

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
- if not present, sample config files should be created
- restore from some given date...

We are planning to add some more entity and store types to extend backzilla options.

Currently supported entity types
======================
- MySQL
- MongoDB
- Directory

Currently supported store types
=====================
- FTP
- SSH
- Directory

Credits
-------
backzilla is maintained by [Wojciech Piekutowski](http://piekutowski.net), Paweł Sobolewski and is funded by [AmberBit](http://amberbit.com).

