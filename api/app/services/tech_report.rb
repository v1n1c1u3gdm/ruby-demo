require "bundler"
require "cgi"
require "socket"
require "etc"

class TechReport
  SENSITIVE_ENV_PATTERN = /(SECRET|PASSWORD|TOKEN|KEY|PWD|PASS)/i

  def initialize(env: ENV)
    @env = env
  end

  def render
    <<~HTML
      <!DOCTYPE html>
      <html lang="pt-BR">
        <head>
          <meta charset="utf-8" />
          <title>ruby-demo :: /tech</title>
          <style>
            body { font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; background: #0d1117; color: #e6edf3; margin: 0; padding: 2rem; }
            h1 { margin-top: 0; }
            section { margin-bottom: 2rem; }
            .tech-table { width: 100%; border-collapse: collapse; background: #161b22; border: 1px solid #30363d; }
            .tech-table th, .tech-table td { border: 1px solid #30363d; padding: 0.5rem 0.75rem; text-align: left; vertical-align: top; }
            .tech-table th { width: 20%; background: #1f242d; font-weight: 600; }
            .badge { display: inline-block; padding: 0.15rem 0.4rem; border-radius: 4px; background: #238636; color: #fff; font-size: 0.75rem; }
            pre { white-space: pre-wrap; word-break: break-word; margin: 0; font-family: 'Fira Code', monospace; }
            .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1rem; }
            .card { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 1rem; }
            .card h2 { margin-top: 0; font-size: 1rem; text-transform: uppercase; letter-spacing: 0.1rem; color: #8b949e; }
            table.compact th { width: auto; }
          </style>
        </head>
        <body>
          <h1>/tech &mdash; ruby-demo diagnostics</h1>
          <p class="badge">Gerado em #{time_stamp}</p>

          #{section_table("Host", host_info)}
          #{section_table("Runtime & Rails", runtime_info)}
          #{section_table("Banco de Dados", database_info)}
          #{section_table("Configuração Rails", configuration_info)}
          #{env_section}
          #{gems_section}
          #{license_section}
        </body>
      </html>
    HTML
  end

  private

  def section_table(title, hash)
    rows = hash.map do |key, value|
      "<tr><th>#{escape(key)}</th><td>#{format_value(value)}</td></tr>"
    end.join

    <<~HTML
      <section>
        <div class="card">
          <h2>#{escape(title)}</h2>
          <table class="tech-table">
            <tbody>
              #{rows}
            </tbody>
          </table>
        </div>
      </section>
    HTML
  end

  def env_section
    rows = sanitized_env.map do |key, value|
      "<tr><th>#{escape(key)}</th><td>#{format_value(value)}</td></tr>"
    end.join

    <<~HTML
      <section>
        <div class="card">
          <h2>Variáveis de Ambiente</h2>
          <table class="tech-table compact">
            <tbody>
              #{rows}
            </tbody>
          </table>
        </div>
      </section>
    HTML
  end

  def gems_section
    rows = gem_info.map do |gem|
      "<tr><td>#{escape(gem[:name])}</td><td>#{escape(gem[:version])}</td><td>#{escape(gem[:path])}</td></tr>"
    end.join

    <<~HTML
      <section>
        <div class="card">
          <h2>Gems carregadas</h2>
          <table class="tech-table compact">
            <thead>
              <tr>
                <th>Gem</th>
                <th>Versão</th>
                <th>Path</th>
              </tr>
            </thead>
            <tbody>
              #{rows}
            </tbody>
          </table>
        </div>
      </section>
    HTML
  end

  def license_section
    <<~HTML
      <section>
        <div class="card">
          <h2>Licença</h2>
          <pre>#{escape(license_text)}</pre>
        </div>
      </section>
    HTML
  end

  def host_info
    {
      "Hostname" => Socket.gethostname,
      "PID" => Process.pid,
      "Plataforma" => RUBY_PLATFORM,
      "Sistema Operacional" => RbConfig::CONFIG["host_os"],
      "Processadores" => Etc.respond_to?(:nprocessors) ? Etc.nprocessors : "N/A",
      "Memória RSS (MB)" => (rss_bytes / 1_048_576.0).round(2)
    }
  end

  def runtime_info
    {
      "Ruby" => RUBY_DESCRIPTION,
      "Rails" => Rails.version,
      "Ambiente" => Rails.env,
      "Timezone" => Rails.application.config.time_zone || "UTC",
      "Boot time" => boot_timestamp,
      "API only" => Rails.application.config.api_only,
      "Eager load" => Rails.application.config.eager_load
    }
  end

  def database_info
    config = fetch_db_config
    {
      "Adapter" => config[:adapter],
      "Database" => config[:database],
      "Host" => config[:host],
      "Port" => config[:port],
      "Username" => config[:username],
      "Encoding" => config[:encoding],
      "Pool size" => ActiveRecord::Base.connection_pool.size
    }
  rescue StandardError => e
    { "Status" => "indisponível: #{e.message}" }
  end

  def configuration_info
    cfg = Rails.application.config
    {
      "Cache classes" => cfg.respond_to?(:cache_classes) ? cfg.cache_classes : "N/A",
      "Consider all requests local" => cfg.respond_to?(:consider_all_requests_local) ? cfg.consider_all_requests_local : "N/A",
      "Log level" => cfg.log_level,
      "Autoload paths" => ActiveSupport::Dependencies.autoload_paths.length,
      "Middleware count" => Rails.application.middleware.count
    }
  end

  def gem_info
    specs = if defined?(Bundler)
              Bundler.load.specs
            else
              Gem.loaded_specs.values
            end

    specs.map { |spec| { name: spec.name, version: spec.version.to_s, path: spec.full_gem_path } }
         .sort_by { |spec| spec[:name] }
  end

  def sanitized_env
    @env.to_h
        .sort_by { |k, _| k }
        .map do |key, value|
          display_value = SENSITIVE_ENV_PATTERN.match?(key) ? "[FILTERED]" : value
          [key, display_value]
        end
  end

  def license_text
    @license_text ||= begin
      path = locate_license_file
      path ? File.read(path) : "Arquivo LICENSE não encontrado."
    end
  end

  def rss_bytes
    `ps -o rss= -p #{Process.pid}`.to_i * 1024
  rescue StandardError
    0
  end

  def boot_timestamp
    Rails.respond_to?(:application) && Rails.application.respond_to?(:booted_at) ? Rails.application.booted_at : "N/D"
  rescue StandardError
    "N/D"
  end

  def format_value(value)
    case value
    when Array
      "<pre>#{escape(value.join("\n"))}</pre>"
    when Hash
      inner = value.map { |k, v| "#{k}: #{v}" }.join("\n")
      "<pre>#{escape(inner)}</pre>"
    else
      escape(value)
    end
  end

  def time_stamp
    Time.current.utc.strftime("%Y-%m-%d %H:%M:%S UTC")
  end

  def escape(value)
    CGI.escapeHTML(value.to_s)
  end

  def locate_license_file
    candidates = [
      Rails.root.join("LICENSE"),
      Rails.root.join("..", "LICENSE"),
      Rails.root.join("..", "..", "LICENSE")
    ].map(&:expand_path)

    candidates.find { |path| File.exist?(path) }
  end

  def fetch_db_config
    if ActiveRecord::Base.respond_to?(:connection_db_config) && ActiveRecord::Base.connection_db_config
      ActiveRecord::Base.connection_db_config.configuration_hash
    else
      config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first
      config ? config.configuration_hash : {}
    end
  end
end

