using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace ModifieR.Models
{
    public partial class SecuritiesGiftCardContext : DbContext
    {
        public virtual DbSet<Customers> Customers { get; set; }
        public virtual DbSet<GiftCards> GiftCards { get; set; }
        public virtual DbSet<Users> Users { get; set; }

        public SecuritiesGiftCardContext(DbContextOptions<SecuritiesGiftCardContext> options)
         : base(options)
        {
        }

        //        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //        {
        //            if (!optionsBuilder.IsConfigured)
        //            {
        //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
        //                optionsBuilder.UseSqlServer(@"Server=WSP6574D;Database=SecuritiesGiftCard;User Id=GiftCard; Password=12345Gift");
        //            }
        //        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Customers>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.AccountNr).HasMaxLength(50);

                entity.Property(e => e.FullName).HasMaxLength(100);

                entity.Property(e => e.PersonalNumber).HasMaxLength(20);
            });

            modelBuilder.Entity<GiftCards>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.BuyerId).HasColumnName("BuyerID");

                entity.Property(e => e.BuyingDate).HasColumnType("datetime");

                entity.Property(e => e.NonRedeemable).HasColumnName("nonRedeemable");

                entity.Property(e => e.RecommendedShare).HasMaxLength(200);

                entity.Property(e => e.RedeemerId).HasColumnName("RedeemerID");

                entity.Property(e => e.RedeemingDate).HasColumnType("datetime");

                entity.Property(e => e.ValueCode).HasMaxLength(100);
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Comment).HasMaxLength(200);

                entity.Property(e => e.UserId)
                    .HasColumnName("UserID")
                    .HasMaxLength(50);
            });
        }
    }
}
