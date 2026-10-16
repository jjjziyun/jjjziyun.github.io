# 让底部社交图标里的邮箱也经过防抓取处理（只在 _config.yml 里 protect_email: true 时生效）。
# al_folio_core 1.0.15 的 about 页面没有把社交图标交给 al_email_protect 处理，
# 这里在页面渲染完成后改写 mailto: 链接：网页源码里不再出现完整邮箱，
# 访客点击时由 al_email_protect 的脚本拼回地址并复制到剪贴板。
require "cgi"

module ProtectSocialEmail
  ANCHOR = %r{<a\b([^>]*?)href=(["'])mailto:([^"']+)\2([^>]*)>(.*?)</a>}im.freeze

  def self.rewrite(html)
    html.gsub(ANCHOR) do
      before, _quote, target, after, inner = Regexp.last_match.captures
      original = Regexp.last_match(0)
      attrs = "#{before} #{after}".gsub(/\s+/, " ").strip
      address = CGI.unescape(target.split("?").first.to_s)
      parts = AlEmailProtect.split_address(address)
      next original unless parts && !inner.include?("@")

      local, domain = parts
      %(<a href="#" class="al-email-protect" data-eu="#{CGI.escapeHTML(local)}" data-ed="#{CGI.escapeHTML(domain)}" #{attrs}>#{inner}</a>)
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless defined?(AlEmailProtect) && AlEmailProtect.enabled?(doc.site)
  next unless doc.output.is_a?(String) && doc.output.include?("mailto:")

  doc.output = ProtectSocialEmail.rewrite(doc.output)
end
