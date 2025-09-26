Python 3.13.7 (tags/v3.13.7:bcee1c3, Aug 14 2025, 14:15:11) [MSC v.1944 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
...     Découpe une sprite sheet en plusieurs images PNG.
...     """
...     # Ouvrir l'image
...     sprite_sheet = Image.open(image_path)
...     sheet_width, sheet_height = sprite_sheet.size
...     sprite_width = sheet_width // num_sprites
...     sprite_height = sheet_height
...
...     # Nom du dossier de sortie (par défaut : nom du fichier sans extension)
...     if output_dir is None:
...         output_dir = os.path.splitext(image_path)[0] + "_sprites"
...
...     os.makedirs(output_dir, exist_ok=True)
...
...     # Découper chaque sprite
...     for i in range(num_sprites):
...         box = (i * sprite_width, 0, (i + 1) * sprite_width, sprite_height)
...         sprite = sprite_sheet.crop(box)
...         output_path = os.path.join(output_dir, f"{os.path.splitext(os.path.basename(image_path))[0]}_{i+1}.png")
...         sprite.save(output_path, "PNG")
...         print(f"✅ Sprite sauvegardé : {output_path}")
...
... if __name__ == "__main__":
...     # Demander à l'utilisateur l'image et le nombre de sprites
...     image_path = input("Chemin de l'image (ex: Soldier-Idle.png) : ").strip()
...     num_sprites = int(input("Nombre de sprites dans la ligne : ").strip())
...
...     decouper_sprite(image_path, num_sprites)
...     print("\n?? Découpage terminé !")
