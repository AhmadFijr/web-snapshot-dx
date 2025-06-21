"use client";

import { useState } from "react";
import Image from "next/image";
import { Camera, Download, FileArchive, Link as LinkIcon, Loader2, Image as ImageIcon, AlertCircle } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Skeleton } from "@/components/ui/skeleton";
import { AppHeader } from "@/components/app-header";
import { useToast } from "@/hooks/use-toast";

type CaptureResult = {
  id: string;
  src: string;
  hint: string;
};

export default function Home() {
  const [url, setUrl] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [images, setImages] = useState<CaptureResult[]>([]);
  const [error, setError] = useState<string | null>(null);
  const { toast } = useToast();

  const handleCapture = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!url) {
      setError("Please enter a URL to capture.");
      return;
    }

    try {
      new URL(url);
    } catch (_) {
      setError("The entered URL is not valid. Please include http:// or https://");
      return;
    }

    setError(null);
    setIsLoading(true);
    setImages([]);

    await new Promise((resolve) => setTimeout(resolve, 2000));

    const mockImages: CaptureResult[] = [
      { id: "1", src: "https://placehold.co/1280x800.png", hint: "website screenshot" },
      { id: "2", src: "https://placehold.co/1280x1600.png", hint: "scrolled content" },
      { id: "3", src: "https://placehold.co/1280x1200.png", hint: "webpage elements" },
      { id: "4", src: "https://placehold.co/1280x900.png", hint: "website footer" },
    ];

    setImages(mockImages);
    setIsLoading(false);
  };
  
  const handleDownloadAll = () => {
    toast({
      title: "Feature Demonstration",
      description: "In a real app, a ZIP file of all images would be downloaded.",
    });
  };

  return (
    <div className="flex flex-col min-h-screen bg-background text-foreground">
      <AppHeader />
      <main className="flex-1 container mx-auto px-4 py-8 md:py-12">
        <section className="text-center max-w-3xl mx-auto">
          <h1 className="text-4xl md:text-5xl font-bold tracking-tight bg-gradient-to-r from-primary to-accent text-transparent bg-clip-text">
            Web Snapshot
          </h1>
          <p className="mt-4 text-lg md:text-xl text-muted-foreground">
            Capture full-page screenshots of any website with a single click. Enter a URL below to get started.
          </p>
        </section>

        <section className="mt-8 md:mt-12 max-w-2xl mx-auto">
          <form onSubmit={handleCapture} className="flex flex-col sm:flex-row items-center gap-2">
            <div className="relative w-full">
              <LinkIcon className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
              <Input
                type="url"
                placeholder="https://example.com"
                className="pl-10 h-12 text-base"
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                disabled={isLoading}
                aria-label="Website URL"
              />
            </div>
            <Button type="submit" size="lg" className="w-full sm:w-auto" disabled={isLoading}>
              {isLoading ? (
                <Loader2 className="animate-spin" />
              ) : (
                <Camera />
              )}
              <span className="ml-2">{isLoading ? "Capturing..." : "Capture"}</span>
            </Button>
          </form>
          {error && (
            <Alert variant="destructive" className="mt-4">
              <AlertCircle className="h-4 w-4" />
              <AlertTitle>Error</AlertTitle>
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}
        </section>

        <section className="mt-8 md:mt-12">
          {isLoading && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {[...Array(2)].map((_, i) => (
                 <Card key={i} className="overflow-hidden">
                    <CardHeader>
                        <Skeleton className="h-6 w-1/2" />
                    </CardHeader>
                    <CardContent>
                       <Skeleton className="w-full aspect-[4/3]" />
                    </CardContent>
                    <CardFooter>
                       <Skeleton className="h-10 w-40" />
                    </CardFooter>
                 </Card>
              ))}
            </div>
          )}
          {images.length > 0 && !isLoading && (
            <div className="animate-in fade-in-50 duration-500">
              <div className="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
                <h2 className="text-2xl font-bold">Captured Images</h2>
                <Button variant="outline" onClick={handleDownloadAll}>
                  <FileArchive />
                  <span className="ml-2">Download All (.zip)</span>
                </Button>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                {images.map((image, index) => (
                  <Card key={image.id} className="overflow-hidden shadow-lg hover:shadow-2xl transition-shadow duration-300">
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2 text-lg font-semibold">
                        <ImageIcon className="text-muted-foreground" />
                        Snapshot {index + 1}
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="bg-muted/30 p-4">
                      <div className="relative aspect-[4/3] w-full rounded-md overflow-hidden border-2 border-border">
                         <Image
                            src={image.src}
                            alt={`Website snapshot ${index + 1}`}
                            fill
                            sizes="(max-width: 768px) 100vw, 50vw"
                            className="object-cover transition-transform hover:scale-105"
                            data-ai-hint={image.hint}
                          />
                      </div>
                    </CardContent>
                    <CardFooter>
                      <Button asChild variant="secondary" className="w-full">
                        <a href={image.src} download={`snapshot-${index + 1}.png`}>
                          <Download />
                          <span className="ml-2">Download Image</span>
                        </a>
                      </Button>
                    </CardFooter>
                  </Card>
                ))}
              </div>
            </div>
          )}
        </section>
      </main>
      <footer className="text-center p-6 text-muted-foreground text-sm">
        Built for demonstration purposes.
      </footer>
    </div>
  );
}
