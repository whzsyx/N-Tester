/**
 * 执行监控抽屉：终端风日志行解析（Web / 接口自动化等页面共用，样式类名与 theme/modules/web-run-monitor.scss 对应）
 */

export function logLineClass(log: unknown): string {
  const s = String(log ?? '')
  if (s.includes('失败')) return 'wa-run-monitor-log-line--error'
  if (s.includes('成功') || s.includes('完成')) return 'wa-run-monitor-log-line--success'
  if (s.includes('补救')) return 'wa-run-monitor-log-line--info'
  return ''
}

/** 正文片段：常见状态词高亮（与时间戳、[标签] 分色叠加） */
export function splitPlainSegmentForKeywords(text: string): Array<{ cls: string; text: string }> {
  if (!text) return []
  const re =
    /(步骤异常|正在执行步骤|正在执行|执行步骤|执行结束|Executable doesn't exist|成功|完成|失败|错误)/gi
  const out: Array<{ cls: string; text: string }> = []
  let last = 0
  let m: RegExpExecArray | null
  while ((m = re.exec(text)) !== null) {
    if (m.index > last) {
      out.push({ cls: 'wa-log-seg wa-log-seg--plain', text: text.slice(last, m.index) })
    }
    const word = m[1]
    let cls = 'wa-log-seg wa-log-seg--plain'
    const w = word.toLowerCase()
    if (/步骤异常|失败|错误|executable doesn't exist/.test(w)) cls = 'wa-log-seg wa-log-seg--kw-error'
    else if (/正在执行|执行步骤/.test(word)) cls = 'wa-log-seg wa-log-seg--kw-run'
    else if (/执行结束|成功|完成/.test(word)) cls = 'wa-log-seg wa-log-seg--kw-ok'
    out.push({ cls, text: word })
    last = m.index + word.length
  }
  if (last < text.length) {
    out.push({ cls: 'wa-log-seg wa-log-seg--plain', text: text.slice(last) })
  }
  if (out.length === 0) {
    out.push({ cls: 'wa-log-seg wa-log-seg--plain', text })
  }
  return out
}

/** 终端风分片：时间戳固定强调色 + [标签] 语义色 + 正文关键词 */
export function parseLogLineForDisplay(line: unknown): Array<{ cls: string; text: string }> {
  const s = String(line ?? '')
  if (!s) return [{ cls: 'wa-log-seg wa-log-seg--plain', text: '' }]
  const raw: Array<{ cls: string; text: string }> = []
  const re =
    /(\[\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\])|(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})|(\d{2}:\d{2}:\d{2}(?:\.\d+)?)|(\[[^\]]+\])/g
  let lastIndex = 0
  let m: RegExpExecArray | null
  while ((m = re.exec(s)) !== null) {
    if (m.index > lastIndex) {
      raw.push(...splitPlainSegmentForKeywords(s.slice(lastIndex, m.index)))
    }
    const full = m[0]
    if (m[1] || m[2] || m[3]) {
      raw.push({ cls: 'wa-log-seg wa-log-seg--time', text: full })
    } else if (m[4]) {
      const inner = full.slice(1, -1)
      let cls = 'wa-log-seg wa-log-seg--tag'
      if (/^JMeter$/i.test(inner)) cls = 'wa-log-seg wa-log-seg--jmeter'
      else if (/^Report$/i.test(inner)) cls = 'wa-log-seg wa-log-seg--report'
      else if (/thread/i.test(inner)) cls = 'wa-log-seg wa-log-seg--thread'
      raw.push({ cls, text: full })
    }
    lastIndex = m.index + full.length
  }
  if (lastIndex < s.length) {
    raw.push(...splitPlainSegmentForKeywords(s.slice(lastIndex)))
  }
  if (raw.length === 0) {
    raw.push(...splitPlainSegmentForKeywords(s))
  }
  return raw
}
