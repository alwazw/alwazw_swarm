# Docker Volume Types Explanation

## Why PostgreSQL Works Without a Local Directory

PostgreSQL in our configuration uses **Docker Named Volumes**, not bind mounts to local directories. Here's the difference:

## 1. Named Volumes (What We're Using)

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
```

**How it works:**
- Docker automatically creates and manages the volume
- Data is stored in Docker's internal directory: `/var/lib/docker/volumes/docker-swarm_postgres_data/_data`
- No need to create local directories
- Docker handles permissions and ownership
- Volumes persist even if containers are removed

**Advantages:**
- ✅ Automatic management by Docker
- ✅ Better performance (especially on Windows/Mac)
- ✅ Proper permissions handling
- ✅ Easy backup with `docker volume` commands
- ✅ Portable across different hosts

## 2. Bind Mounts (Alternative Approach)

```yaml
volumes:
  - ./postgres_data:/var/lib/postgresql/data
```

**How it works:**
- Maps a local directory to container directory
- Requires the local directory to exist
- Uses host filesystem directly
- Manual permission management needed

**When to use:**
- When you need direct access to files from host
- For configuration files you want to edit
- For development environments

## Current Volume Status

All these volumes were automatically created by Docker:

```
docker-swarm_postgres_data      -> PostgreSQL database files
docker-swarm_redis_data         -> Redis data files
docker-swarm_grafana_data       -> Grafana dashboards and settings
docker-swarm_heimdall_config    -> Heimdall configuration
docker-swarm_pgadmin_data       -> pgAdmin settings and connections
... and 14 more volumes
```

## Where Is the Data Actually Stored?

```bash
# PostgreSQL data location
/var/lib/docker/volumes/docker-swarm_postgres_data/_data

# To see all volume locations:
docker volume inspect docker-swarm_postgres_data
```

## Mixed Approach Example

Some services use both types:

```yaml
plex:
  volumes:
    - plex_config:/config                    # Named volume for config
    - /home/ubuntu/media:/media              # Bind mount for media files
```

This gives us:
- **Named volume** for application config (Docker managed)
- **Bind mount** for media files (direct host access)

## Benefits of Our Current Setup

1. **No directory creation needed** - Docker handles everything
2. **Proper permissions** - No permission issues
3. **Data persistence** - Survives container recreation
4. **Easy backup** - Use `docker volume` commands
5. **Portability** - Works the same on any Docker host

## Backup and Restore

```bash
# Backup a volume
docker run --rm -v docker-swarm_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .

# Restore a volume
docker run --rm -v docker-swarm_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres_backup.tar.gz -C /data
```

This is why PostgreSQL works perfectly without creating any local directories!

