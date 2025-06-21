"use client";

import { useState } from "react";
import { Settings } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { useToast } from "@/hooks/use-toast";


export function SettingsDialog() {
  const [format, setFormat] = useState("png");
  const [quality, setQuality] = useState("high");
  const { toast } = useToast();

  const handleSaveChanges = () => {
    // In a real app, you would save these settings to context, local storage, or a backend.
    toast({
      title: "Settings Saved",
      description: `Format set to ${format.toUpperCase()} and quality set to ${quality}.`,
    });
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="ghost" size="icon">
          <Settings className="h-5 w-5" />
          <span className="sr-only">Settings</span>
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Capture Settings</DialogTitle>
          <DialogDescription>
            Adjust the quality and format for your website snapshots. Changes are for demonstration.
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-6 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="image-format" className="text-right">
              Format
            </Label>
            <Select defaultValue="png" onValueChange={setFormat}>
                <SelectTrigger id="image-format" className="col-span-3">
                    <SelectValue placeholder="Select format" />
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="png">PNG</SelectItem>
                    <SelectItem value="jpeg">JPEG</SelectItem>
                    <SelectItem value="webp">WebP</SelectItem>
                </SelectContent>
            </Select>
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Quality</Label>
            <RadioGroup defaultValue="high" className="col-span-3 flex items-center gap-4" onValueChange={setQuality}>
              <div className="flex items-center space-x-2">
                <RadioGroupItem value="high" id="q-high" />
                <Label htmlFor="q-high">High</Label>
              </div>
              <div className="flex items-center space-x-2">
                <RadioGroupItem value="medium" id="q-medium" />
                <Label htmlFor="q-medium">Medium</Label>
              </div>
              <div className="flex items-center space-x-2">
                <RadioGroupItem value="low" id="q-low" />
                <Label htmlFor="q-low">Low</Label>
              </div>
            </RadioGroup>
          </div>
        </div>
        <DialogFooter>
            <DialogClose asChild>
                <Button type="submit" onClick={handleSaveChanges}>Save changes</Button>
            </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
