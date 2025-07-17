# Meilisearch Railway Template

Deploy [Meilisearch](https://www.meilisearch.com/), the lightning-fast search engine, to [Railway](https://railway.app) with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/meilisearch)

## Features

- 🚀 One-click deployment to Railway
- 🔄 Flexible version management (deploy any Meilisearch version)
- 🔒 Secure by default with master key authentication
- 💾 Persistent data storage with Railway volumes
- 🐳 Docker-based deployment for consistency
- 🛠️ Easy local development setup
- 📊 Health checks and monitoring ready
- 🔧 Customizable environment configuration

## Quick Start

### Deploy to Railway

1. Click the "Deploy on Railway" button above
2. Configure your environment variables:
   - `MEILI_MASTER_KEY` (required) - Your secure master key
   - `MEILISEARCH_VERSION` (optional) - Version to deploy (default: `latest`)
3. Railway will automatically deploy your Meilisearch instance

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/meilisearch-railway
cd meilisearch-railway

# Quick start with auto-generated master key
make run

# Or use docker-compose
make deploy-local

# Access Meilisearch at http://localhost:7700
```

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `MEILI_MASTER_KEY` | Master key for securing your instance | - | ✅ |
| `MEILISEARCH_VERSION` | Meilisearch version to deploy | `latest` | ❌ |
| `MEILI_ENV` | Environment mode (`production`/`development`) | `production` | ❌ |
| `MEILI_LOG_LEVEL` | Log verbosity (`ERROR`/`WARN`/`INFO`/`DEBUG`/`TRACE`) | `INFO` | ❌ |
| `MEILI_NO_ANALYTICS` | Disable anonymous telemetry | `false` | ❌ |

### Advanced Configuration

Additional environment variables available:

- `MEILI_DB_PATH` - Database file path (default: `/data/data.ms`)
- `MEILI_SNAPSHOT_DIR` - Snapshot directory (default: `/data/snapshots`)
- `MEILI_DUMP_DIR` - Dump directory (default: `/data/dumps`)
- `MEILI_IMPORT_SNAPSHOT` - Import snapshot on startup
- `MEILI_IMPORT_DUMP` - Import dump on startup
- `MEILI_SCHEDULE_SNAPSHOT` - Snapshot schedule in seconds

## Usage

### Available Commands

```bash
# Build and run
make build              # Build Docker image
make run               # Run Meilisearch locally
make stop              # Stop running container

# Testing
make test              # Test the build
make test-versions     # Test multiple versions

# Deployment
make deploy-local      # Deploy with docker-compose
make deploy-railway    # Interactive Railway deployment

# Utilities
make logs              # View container logs
make shell             # Access container shell
make clean             # Clean up everything
make generate-key      # Generate secure master key
```

### Testing Your Deployment

```bash
# Check health
curl https://your-app.railway.app/health

# Get version (requires authentication)
curl -H "Authorization: Bearer YOUR_MASTER_KEY" \
  https://your-app.railway.app/version

# Create an index
curl -X POST 'https://your-app.railway.app/indexes' \
  -H 'Authorization: Bearer YOUR_MASTER_KEY' \
  -H 'Content-Type: application/json' \
  --data-binary '{
    "uid": "movies",
    "primaryKey": "id"
  }'
```

## Security

### Master Key

The master key is required for production deployments. It protects your Meilisearch instance from unauthorized access.

**Generate a secure master key:**
```bash
make generate-key
# or
openssl rand -base64 32
```

### Best Practices

1. **Always use a strong master key** in production
2. **Set `MEILI_ENV=production`** for production deployments
3. **Enable HTTPS** through Railway's automatic SSL
4. **Regularly backup** your data using Meilisearch dumps
5. **Monitor logs** and set appropriate log levels

## Development

### Project Structure

```
meilisearch-railway/
├── .github/
│   └── workflows/
│       └── test.yml       # CI/CD pipeline
├── .env.example           # Environment template
├── Dockerfile             # Container definition
├── docker-compose.yml     # Local orchestration
├── railway.json           # Railway configuration
├── Makefile              # Command shortcuts
└── README.md             # This file
```

### Testing Multiple Versions

```bash
# Test specific version
make test MEILISEARCH_VERSION=v1.15

# Test multiple versions automatically
make test-versions
```

### Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes locally (`make test`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## Troubleshooting

### Common Issues

**Port binding errors on Railway**
- Railway automatically assigns a port via `$PORT`
- The template handles this automatically

**Authentication errors**
- Ensure your master key is set correctly
- Use the `Authorization: Bearer YOUR_KEY` header

**Data persistence**
- Railway volumes are mounted at `/data`
- Data persists across deployments

**Version compatibility**
- Check [Meilisearch releases](https://github.com/meilisearch/meilisearch/releases)
- Test new versions locally first

### Getting Help

- 📚 [Meilisearch Documentation](https://www.meilisearch.com/docs)
- 🚂 [Railway Documentation](https://docs.railway.app)
- 💬 [Meilisearch Community](https://discord.meilisearch.com)
- 🐛 [Report Issues](https://github.com/yourusername/meilisearch-railway/issues)

## License

This template is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- [Meilisearch](https://www.meilisearch.com) for the amazing search engine
- [Railway](https://railway.app) for the deployment platform
- The open source community for continuous improvements

---

Made with ❤️ for the search community