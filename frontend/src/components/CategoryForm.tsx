import React, { useState } from "react";
import { TextField, Button } from "../vibes";

interface CategoryFormProps {
  onSubmit: (name: string) => Promise<void>;
  onCancel: () => void;
}

export function CategoryForm({ onSubmit, onCancel }: CategoryFormProps) {
  const [name, setName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = name.trim();
    if (!trimmed) {
      setError("Category name can't be blank");
      return;
    }
    setIsSubmitting(true);
    try {
      await onSubmit(trimmed);
      setName("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to create category");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCancel = () => {
    setName("");
    setError(null);
    onCancel();
  };

  const formStyle: React.CSSProperties = {
    display: "flex",
    flexDirection: "column",
    gap: "1rem",
  };

  const buttonGroupStyle: React.CSSProperties = {
    display: "flex",
    gap: "0.5rem",
    marginTop: "0.5rem",
  };

  const errorStyle: React.CSSProperties = {
    color: "#dc2626",
    fontSize: "0.875rem",
    margin: 0,
  };

  return (
    <form onSubmit={handleSubmit} style={formStyle}>
      <TextField
        label="Category Name"
        type="text"
        placeholder="e.g. Entertainment"
        value={name}
        onChange={(e) => {
          setName(e.target.value);
          setError(null);
        }}
        fullWidth
      />
      {error && <p style={errorStyle}>{error}</p>}
      <div style={buttonGroupStyle}>
        <Button type="submit" variant="primary" disabled={isSubmitting} fullWidth>
          {isSubmitting ? "Adding..." : "Add Category"}
        </Button>
        <Button type="button" variant="secondary" onClick={handleCancel} disabled={isSubmitting}>
          Cancel
        </Button>
      </div>
    </form>
  );
}
