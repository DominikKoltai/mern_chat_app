import { describe, test, expect, vi } from "vitest";
import { render } from "@testing-library/react";
import Chat from "../src/Chat";

describe("Chat", () => {
  test("should establish a WebSocket connection", () => {
    const mockWebSocket = {
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
    };

    global.WebSocket = vi.fn().mockImplementation(() => mockWebSocket);

    render(<Chat />);

    expect(global.WebSocket).toHaveBeenCalledWith("ws://localhost:4000");
    expect(mockWebSocket.addEventListener).toHaveBeenCalledWith(
      "message",
      expect.any(Function)
    );
    expect(mockWebSocket.addEventListener).toHaveBeenCalledWith(
      "close",
      expect.any(Function)
    );
  });
});
