"use client";

import { Camera } from "lucide-react";
import { SettingsDialog } from "./settings-dialog";

export function AppHeader() {
  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 items-center">
        <div className="mr-4 flex items-center">
          <Camera className="h-6 w-6 mr-2 text-primary" />
          <span className="font-bold">Web Snapshot</span>
        </div>
        <div className="flex flex-1 items-center justify-end space-x-2">
          <SettingsDialog />
        </div>
      </div>
    </header>
  );
}
