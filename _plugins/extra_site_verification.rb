# 允许在 _config.yml 里填多个 Google Search Console 验证码。
# al_folio_core 1.0.15 的 metadata.liquid 只输出 google_site_verification 一个标签；
# 网站换域名后，新旧两个网址在 Search Console 里各有一个验证码，都需要保留。
# 这里在页面渲染完成后，把 google_site_verification_extra 里的验证码插在原标签后面。
require "cgi"

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  extra = Array(doc.site.config["google_site_verification_extra"]).compact
  next if extra.empty?
  next unless doc.output.is_a?(String)

  tags = extra.map { |code| %(<meta name="google-site-verification" content="#{CGI.escapeHTML(code.to_s)}">) }.join
  doc.output = doc.output.sub(/<meta name="google-site-verification"[^>]*>/) { |m| m + tags }
end
