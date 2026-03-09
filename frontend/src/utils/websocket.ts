/**
 * WebSocket 客户端工具类
 * 提供自动重连、心跳检测、消息队列等功能
 */

export interface WebSocketCallbacks {
  onOpen?: () => void
  onMessage: (data: any) => void
  onError?: (error: Error) => void
  onClose?: () => void
  onMaxReconnectFailed?: () => void
}

export class WebSocketClient {
  private ws: WebSocket | null = null
  private url: string
  private callbacks: WebSocketCallbacks
  private reconnectAttempts = 0
  private maxReconnectAttempts = 5
  private reconnectDelay = 1000
  private heartbeatInterval: number | null = null
  private heartbeatTimeout: number | null = null
  private isManualClose = false
  private messageQueue: any[] = []  // 消息队列，用于连接建立前的消息
  
  constructor(url: string, callbacks: WebSocketCallbacks) {
    this.url = url
    this.callbacks = callbacks
  }
  
  /**
   * 建立 WebSocket 连接
   */
  connect() {
    console.log('[WebSocket] Connecting to:', this.url)
    this.isManualClose = false
    
    try {
      this.ws = new WebSocket(this.url)
      this.setupEventHandlers()
    } catch (error) {
      console.error('[WebSocket] Connection error:', error)
      this.callbacks.onError?.(error as Error)
      this.scheduleReconnect()
    }
  }
  
  /**
   * 设置事件处理器
   */
  private setupEventHandlers() {
    if (!this.ws) return
    
    this.ws.onopen = () => {
      console.log('[WebSocket] Connected')
      this.reconnectAttempts = 0
      this.startHeartbeat()
      this.callbacks.onOpen?.()
      
      // 发送队列中的消息
      this.flushMessageQueue()
    }
    
    this.ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data)
        
        // 处理心跳响应
        if (data.type === 'pong') {
          console.log('[WebSocket] Received pong')
          this.resetHeartbeatTimeout()
          return
        }
        
        this.callbacks.onMessage(data)
      } catch (error) {
        console.error('[WebSocket] Failed to parse message:', error)
      }
    }
    
    this.ws.onerror = (error) => {
      console.error('[WebSocket] Error:', error)
      this.callbacks.onError?.(new Error('WebSocket connection error'))
    }
    
    this.ws.onclose = (event) => {
      console.log('[WebSocket] Closed:', event.code, event.reason)
      this.stopHeartbeat()
      this.callbacks.onClose?.()
      
      // 如果不是手动关闭，尝试重连
      if (!this.isManualClose) {
        this.scheduleReconnect()
      }
    }
  }
  
  /**
   * 启动心跳检测
   */
  private startHeartbeat() {
    this.heartbeatInterval = window.setInterval(() => {
      if (this.ws?.readyState === WebSocket.OPEN) {
        console.log('[WebSocket] Sending ping')
        this.send({ type: 'ping' })
        
        // 设置超时检测
        this.heartbeatTimeout = window.setTimeout(() => {
          console.warn('[WebSocket] Heartbeat timeout, closing connection')
          this.ws?.close()
        }, 10000) // 10秒超时
      }
    }, 30000) // 每30秒发送心跳
  }
  
  /**
   * 重置心跳超时
   */
  private resetHeartbeatTimeout() {
    if (this.heartbeatTimeout) {
      clearTimeout(this.heartbeatTimeout)
      this.heartbeatTimeout = null
    }
  }
  
  /**
   * 停止心跳检测
   */
  private stopHeartbeat() {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval)
      this.heartbeatInterval = null
    }
    this.resetHeartbeatTimeout()
  }
  
  /**
   * 安排重连
   */
  private scheduleReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.error('[WebSocket] Max reconnect attempts reached')
      this.callbacks.onMaxReconnectFailed?.()
      return
    }
    
    this.reconnectAttempts++
    const delay = this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1)
    console.log(`[WebSocket] Reconnecting in ${delay}ms... (attempt ${this.reconnectAttempts}/${this.maxReconnectAttempts})`)
    
    setTimeout(() => {
      this.connect()
    }, delay)
  }
  
  /**
   * 发送消息
   */
  send(data: any) {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(data))
    } else {
      // 如果连接未建立，将消息加入队列
      console.warn('[WebSocket] Connection not ready, queueing message')
      this.messageQueue.push(data)
    }
  }
  
  /**
   * 发送队列中的消息
   */
  private flushMessageQueue() {
    if (this.messageQueue.length > 0) {
      console.log(`[WebSocket] Flushing ${this.messageQueue.length} queued messages`)
      while (this.messageQueue.length > 0) {
        const message = this.messageQueue.shift()
        if (this.ws?.readyState === WebSocket.OPEN) {
          this.ws.send(JSON.stringify(message))
        }
      }
    }
  }
  
  /**
   * 手动关闭连接
   */
  close() {
    console.log('[WebSocket] Manual close')
    this.isManualClose = true
    this.stopHeartbeat()
    this.messageQueue = []  // 清空消息队列
    this.ws?.close()
  }
  
  /**
   * 获取连接状态
   */
  getReadyState(): number {
    return this.ws?.readyState ?? WebSocket.CLOSED
  }
  
  /**
   * 检查是否已连接
   */
  isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN
  }
}
